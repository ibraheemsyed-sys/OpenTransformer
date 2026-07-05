module tb_alu_8bit;

    import alu_pkg::*;
    logic [7:0] a;
    logic [7:0] b;
    alu_op_e opcode;
    logic [7:0] result;

    alu_8bit utt(
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result)
    );

    initial begin
        $dumpfile("alu_8bit.vcd");
        $dumpvars(0, tb_alu_8bit);
        
        $display("Time | A | B | opcode | result ");
        $display("--------------------------------");
        
        //Add
        a=8'd10; b=8'd8; opcode=OP_ADD; #10; 
        $display("%0t   |  %0d |  %0d |   %0d  |   %0d", $time, a, b, opcode, result);
        //Sub
        a=8'd10; b=8'd8; opcode=OP_SUB; #10; 
        $display("%0t   |  %0d |  %0d |   %0d  |   %0d", $time, a, b, opcode, result);
        //Not
        a=8'd10; b=8'd8; opcode=OP_NOT; #10; 
        $display("%0t   |  %0d |  %0d |   %0d  |   %0d", $time, a, b, opcode, result);
        //OR
        a=8'd10; b=8'd8; opcode=OP_OR; #10; 
        $display("%0t   |  %0d |  %0d |   %0d  |   %0d", $time, a, b, opcode, result);
        //XOR
         a=8'd10; b=8'd8; opcode=OP_XOR; #10; 
        $display("%0t   |  %0d |  %0d |   %0d  |   %0d", $time, a, b, opcode, result);
        //Add
         a=8'd10; b=8'd8; opcode=OP_AND; #10; 
        $display("%0t   |  %0d |  %0d |   %0d  |   %0d", $time, a, b, opcode, result);
    end

endmodule
