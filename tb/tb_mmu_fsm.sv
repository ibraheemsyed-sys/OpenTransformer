import mmu_pkg::*;

class Transaction;
  rand bit [3:0] addr;
  rand bit [DATA_WIDTH-1:0] wdata;
  rand bit is_write;
endclass

class Driver;
  virtual mmu_interface.host vif;

  function new(virtual mmu_interface.host vif);
    this.vif = vif;
  endfunction

  task automatic drive(Transaction tr);
    @(posedge vif.clk);
    while (!vif.ready) @(posedge vif.clk);

    vif.addr <= tr.addr;
    vif.wdata <= tr.wdata;
    vif.write_en <= tr.is_write;
    vif.read_en <= !tr.is_write;

    @(posedge vif.clk);
    vif.write_en <= 1'b0;
    vif.read_en <= 1'b0;

    while (!vif.valid && !vif.error) @(posedge vif.clk);

    $display("t=%0t addr=%0h write=%0b rdata=%0h valid=%0b error=%0b",
              $time, tr.addr, tr.is_write, vif.rdata, vif.valid, vif.error);
  endtask
endclass

module reg_file_stub (
  input logic clk,
  input logic rst_n,
  input logic [3:0] w_addr,
  input logic [7:0] w_data,
  input logic w_en,
  input logic [3:0] r_addr_a,
  output logic [7:0] r_data_a
);
  logic [7:0] mem [0:15];
  assign r_data_a = mem[r_addr_a];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int i = 0; i < 16; i++) mem[i] <= '0;
    end else if (w_en) begin
      mem[w_addr] <= w_data;
    end
  end
endmodule

module tb_mmu_fsm;

  logic clk = 0;
  logic rst_n;
  always #5 clk = ~clk;

  mmu_interface bus (.clk(clk), .rst_n(rst_n));

  logic [3:0] w_addr;
  logic [7:0] w_data;
  logic w_en;
  logic [3:0] r_addr_a;
  logic [7:0] r_data_a;

  mmu_fsm dut (
    .bus(bus.mmu),
    .w_addr(w_addr),
    .w_data(w_data),
    .w_en(w_en),
    .r_addr_a(r_addr_a),
    .r_data_a(r_data_a)
  );

  reg_file_stub rfile (
    .clk(clk), .rst_n(rst_n),
    .w_addr(w_addr), .w_data(w_data), .w_en(w_en),
    .r_addr_a(r_addr_a), .r_data_a(r_data_a)
  );

  initial begin
    Driver drv;
    Transaction tr;

    $dumpfile("mmu_fsm.vcd");
    $dumpvars(0, tb_mmu_fsm);

    rst_n = 0;
    bus.addr = '0;
    bus.wdata = '0;
    bus.write_en = 0;
    bus.read_en = 0;
    repeat (3) @(posedge clk);
    rst_n = 1;
    @(posedge clk);

    drv = new(bus.host);

    tr = new();
    tr.addr = 4'h3;
    tr.wdata = 8'hA5;
    tr.is_write = 1;
    drv.drive(tr);

    tr = new();
    tr.addr = 4'h3;
    tr.wdata = 8'h00;
    tr.is_write = 0;
    drv.drive(tr);

    $finish;
  end

endmodule