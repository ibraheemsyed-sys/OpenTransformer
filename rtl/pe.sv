module pe #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)

(
input  logic clk,
input  logic rst_n,
input  logic clear,
input  logic enable,
input  logic[DATA_WIDTH-1:0] a_in,
input  logic[DATA_WIDTH-1:0] b_in,
output  logic[DATA_WIDTH-1:0] a_out,
output  logic[DATA_WIDTH-1:0] b_out,
output  logic[ACC_WIDTH-1:0] acc
);

mac #(
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
) mac_inst (
    .clk(clk),
    .rst_n(rst_n),
    .clear(clear),
    .enable(enable),
    .a(a_in),
    .b(b_in),
    .acc(acc)
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_out <= '0;
        b_out <= '0;
    end
    else if (enable) begin
        a_out <= a_in;
        b_out <= b_in;
    end
end;
endmodule
