package alu_pkg;

    typedef enum logic [2:0] {
        OP_ADD = 3'b000, // add
        OP_SUB = 3'b001, // Sub
        OP_AND = 3'b010, //  AND
        OP_OR  = 3'b011, //  OR
        OP_XOR = 3'b100, //  XOR
        OP_NOT = 3'b101  //  NOT (Invert A)
        
    } alu_op_e;
endpackage

