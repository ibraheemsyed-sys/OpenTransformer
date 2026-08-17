module mac #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)

(
    input  logic clk,
    input  logic rst_n,
    input  logic clear,
    input  logic enable,
    input  logic [DATA_WIDTH-1:0] a,
    input  logic [DATA_WIDTH-1:0] b,
    output logic [ACC_WIDTH-1:0]  acc
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
            acc <= '0;
    end else if (clear) begin
            acc <= '0;
    end else if (enable) begin
            acc <= acc + (a * b);
        end
    end

endmodule
