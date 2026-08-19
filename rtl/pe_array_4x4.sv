module pe_array_4x4 #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)(
    input logic clk,
    input logic rst_n,
    input logic clear,
    input logic enable,

    input logic [DATA_WIDTH-1:0] a_row0,
    input logic [DATA_WIDTH-1:0] a_row1,
    input logic [DATA_WIDTH-1:0] a_row2,
    input logic [DATA_WIDTH-1:0] a_row3,

    input logic [DATA_WIDTH-1:0] b_col0,
    input logic [DATA_WIDTH-1:0] b_col1,
    input logic [DATA_WIDTH-1:0] b_col2,
    input logic [DATA_WIDTH-1:0] b_col3,

    output logic [ACC_WIDTH-1:0] acc00,
    output logic [ACC_WIDTH-1:0] acc01,
    output logic [ACC_WIDTH-1:0] acc02,
    output logic [ACC_WIDTH-1:0] acc03,

    output logic [ACC_WIDTH-1:0] acc10,
    output logic [ACC_WIDTH-1:0] acc11,
    output logic [ACC_WIDTH-1:0] acc12,
    output logic [ACC_WIDTH-1:0] acc13,

    output logic [ACC_WIDTH-1:0] acc20,
    output logic [ACC_WIDTH-1:0] acc21,
    output logic [ACC_WIDTH-1:0] acc22,
    output logic [ACC_WIDTH-1:0] acc23,

    output logic [ACC_WIDTH-1:0] acc30,
    output logic [ACC_WIDTH-1:0] acc31,
    output logic [ACC_WIDTH-1:0] acc32,
    output logic [ACC_WIDTH-1:0] acc33
);


    logic [DATA_WIDTH-1:0] a_bus [0:3][0:4];

    logic [DATA_WIDTH-1:0] b_bus [0:4][0:3];

    logic [ACC_WIDTH-1:0] acc_bus [0:3][0:3];


    // Feed A values into the left side of the array.
    assign a_bus[0][0] = a_row0;
    assign a_bus[1][0] = a_row1;
    assign a_bus[2][0] = a_row2;
    assign a_bus[3][0] = a_row3;

    // Feed B values into the top of the array.
    assign b_bus[0][0] = b_col0;
    assign b_bus[0][1] = b_col1;
    assign b_bus[0][2] = b_col2;
    assign b_bus[0][3] = b_col3;


    // Generate all 16 processing elements.
    genvar r, c;

    generate
        for (r = 0; r < 4; r = r + 1) begin : ROW
            for (c = 0; c < 4; c = c + 1) begin : COL

                pe #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .ACC_WIDTH(ACC_WIDTH)
                ) pe_inst (
                    .clk(clk),
                    .rst_n(rst_n),
                    .clear(clear),
                    .enable(enable),

                    .a_in(a_bus[r][c]),
                    .b_in(b_bus[r][c]),

                    .a_out(a_bus[r][c+1]),
                    .b_out(b_bus[r+1][c]),

                    .acc(acc_bus[r][c])
                );

            end
        end
    endgenerate



    assign acc00 = acc_bus[0][0];
    assign acc01 = acc_bus[0][1];
    assign acc02 = acc_bus[0][2];
    assign acc03 = acc_bus[0][3];

    assign acc10 = acc_bus[1][0];
    assign acc11 = acc_bus[1][1];
    assign acc12 = acc_bus[1][2];
    assign acc13 = acc_bus[1][3];

    assign acc20 = acc_bus[2][0];
    assign acc21 = acc_bus[2][1];
    assign acc22 = acc_bus[2][2];
    assign acc23 = acc_bus[2][3];

    assign acc30 = acc_bus[3][0];
    assign acc31 = acc_bus[3][1];
    assign acc32 = acc_bus[3][2];
    assign acc33 = acc_bus[3][3];

endmodule
