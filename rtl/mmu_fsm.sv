import mmu_pkg::*;

module mmu_fsm (
  mmu_interface.mmu bus,

  output logic [3:0]            w_addr,
  output logic [DATA_WIDTH-1:0] w_data,
  output logic w_en,
  output logic [3:0]            r_addr_a,
  input  logic [DATA_WIDTH-1:0] r_data_a
);

  mmu_state_e state, next_state;

  logic [ADDR_WIDTH-1:0] addr_r;
  logic [DATA_WIDTH-1:0] wdata_r;
  logic [DATA_WIDTH-1:0] rdata_r;
  logic is_write_r;
  logic error_r;
  logic addr_valid;

  always_ff @(posedge bus.clk or negedge bus.rst_n) begin
    if (!bus.rst_n) begin
      state      <= S_IDLE;
      addr_r     <= '0;
      wdata_r    <= '0;
      rdata_r    <= '0;
      is_write_r <= 1'b0;
      error_r    <= 1'b0;
    end else begin
      state <= next_state;

      if (state == S_IDLE && (bus.read_en || bus.write_en)) begin
        error_r    <= 1'b0;
        addr_r     <= bus.addr;
        wdata_r    <= bus.wdata;
        is_write_r <= bus.write_en;
      end

      if (state == S_DECODE && !addr_valid) begin
        error_r <= 1'b1;
      end

      if (state == S_ACCESS && !is_write_r) begin
        rdata_r <= r_data_a;
      end
    end
  end

  always_comb begin
    addr_valid = (addr_r <= RF_TOP) && (addr_r >= RF_BASE);

    next_state = state;
    bus.ready  = 1'b0;
    bus.valid  = 1'b0;
    bus.error  = 1'b0;
    bus.rdata  = rdata_r;
    w_addr     = addr_r[3:0];
    w_data     = wdata_r;
    w_en       = 1'b0;
    r_addr_a   = addr_r[3:0];

    case (state)

      S_IDLE: begin
        bus.ready = 1'b1;
        if (bus.read_en || bus.write_en)
          next_state = S_DECODE;
      end

      S_DECODE: begin
        if (addr_valid)
          next_state = S_ACCESS;
        else
          next_state = S_DONE;
      end

      S_ACCESS: begin
        if (is_write_r) begin
          w_en = 1'b1;
        end
        next_state = S_DONE;
      end

      S_DONE: begin
        if (error_r == 1'b1) begin
          bus.valid = 1'b0;
          bus.error = 1'b1;
          next_state = S_IDLE;
        end else begin
          bus.valid = 1'b1;
          bus.error = 1'b0;
          next_state = S_IDLE;
        end
      end

      default: next_state = S_IDLE;
    endcase
  end

endmodule : mmu_fsm
