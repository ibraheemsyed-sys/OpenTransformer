import mmu_pkg::*;

interface mmu_interface (
  input logic clk,
  input logic rst_n
);

  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] wdata;
  logic [DATA_WIDTH-1:0] rdata;
  logic write_en;
  logic read_en;
  logic ready;
  logic valid;
  logic error;

  modport host (
    input  clk, rst_n,
    output addr, wdata, write_en, read_en,
    input  ready, rdata, valid, error
  );

  modport mmu (
    input  clk, rst_n,
    input  addr, wdata, write_en, read_en,
    output ready, rdata, valid, error
  );

endinterface : mmu_interface