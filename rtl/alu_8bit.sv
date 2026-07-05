module alu_8bit(
    input logic [7:0] a,
    input logic [7:0] b,
    input alu_pkg::alu_op_e opcode,
    output logic [7:0] result
);

import alu_pkg::*;


always_comb begin

case (opcode)
    OP_ADD: result = a + b;
    OP_SUB: result = a - b;
    OP_AND: result = a & b;
    OP_NOT: result = ~a;
    OP_OR: result = a | b;
    OP_XOR: result= a ^ b;
    default: result = 8'b0;
endcase
end
endmodule
