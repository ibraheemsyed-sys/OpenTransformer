module pe_array_2x2 #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)(
    input  logic clk,
    input  logic rst_n,
    input  logic clear,
    input  logic enable,

    input  logic [DATA_WIDTH-1:0] a_row0,
    input  logic [DATA_WIDTH-1:0] a_row1,
    input  logic [DATA_WIDTH-1:0] b_col0,
    input  logic [DATA_WIDTH-1:0] b_col1,

    output logic [DATA_WIDTH-1:0] a_right0,
    output logic [DATA_WIDTH-1:0] a_right1,
    output logic [DATA_WIDTH-1:0] b_bottom0,
    output logic [DATA_WIDTH-1:0] b_bottom1,

    output logic [ACC_WIDTH-1:0] acc00,
    output logic [ACC_WIDTH-1:0] acc01,
    output logic [ACC_WIDTH-1:0] acc10,
    output logic [ACC_WIDTH-1:0] acc11
);
logic [DATA_WIDTH-1:0] a00_to_01;
logic [DATA_WIDTH-1:0] b00_to_10;
logic [DATA_WIDTH-1:0] a10_to_11;
logic [DATA_WIDTH-1:0] b01_to_11;

pe #(
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
) 
pe00 (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .enable(enable),

    .a_in(a_row0),
    .b_in(b_col0),

    .a_out(a00_to_01),
    .b_out(b00_to_10),

    .acc(acc00)
);
pe #(
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
) pe01 (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .enable(enable),

    .a_in(a00_to_01),
    .b_in(b_col1),

    .a_out(a_right0),
    .b_out(b01_to_11),

    .acc(acc01)
);
pe #(
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
) pe10 (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .enable(enable),

    .a_in(a_row1),
    .b_in(b00_to_10),

    .a_out(a10_to_11),
    .b_out(b_bottom0),

    .acc(acc10)
);
pe #(
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
) pe11 (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .enable(enable),

    .a_in(a10_to_11),
    .b_in(b01_to_11),

    .a_out(a_right1),
    .b_out(b_bottom1),

    .acc(acc11)
);
endmodule
