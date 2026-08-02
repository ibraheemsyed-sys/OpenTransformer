package mmu_pkg;

  parameter int ADDR_WIDTH = 8;
  parameter int DATA_WIDTH = 8;

  parameter logic [ADDR_WIDTH-1:0] RF_BASE = 8'h00;
  parameter logic [ADDR_WIDTH-1:0] RF_TOP  = 8'h0F;

  typedef enum logic [1:0] {
    S_IDLE,
    S_DECODE,
    S_ACCESS,
    S_DONE
  } mmu_state_e;

endpackage : mmu_pkg