module matmul_16x16 #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)(
    input  logic clk,
    input  logic rst_n,
    input  logic start,

    input  logic load_we,
    input  logic load_b,
    input  logic [3:0] load_row,
    input  logic [3:0] load_col,
    input  logic [DATA_WIDTH-1:0] load_data,

    input  logic [3:0] result_row,
    input  logic [3:0] result_col,
    output logic [ACC_WIDTH-1:0] result_data,

    output logic busy,
    output logic done
);

    logic [DATA_WIDTH-1:0] a_mem [0:255];
    logic [DATA_WIDTH-1:0] b_mem [0:255];

    (* ram_style = "block" *)
    logic [ACC_WIDTH-1:0] c_mem [0:255];

    logic clear_array;
    logic enable_array;
    logic save_result;

    logic [1:0] tile_row;
    logic [1:0] tile_col;
    logic [1:0] k_tile;

    logic [3:0] cycle_count;
    logic [3:0] save_index;

    logic [DATA_WIDTH-1:0] a_row0;
    logic [DATA_WIDTH-1:0] a_row1;
    logic [DATA_WIDTH-1:0] a_row2;
    logic [DATA_WIDTH-1:0] a_row3;

    logic [DATA_WIDTH-1:0] b_col0;
    logic [DATA_WIDTH-1:0] b_col1;
    logic [DATA_WIDTH-1:0] b_col2;
    logic [DATA_WIDTH-1:0] b_col3;

    logic [ACC_WIDTH-1:0] acc00;
    logic [ACC_WIDTH-1:0] acc01;
    logic [ACC_WIDTH-1:0] acc02;
    logic [ACC_WIDTH-1:0] acc03;

    logic [ACC_WIDTH-1:0] acc10;
    logic [ACC_WIDTH-1:0] acc11;
    logic [ACC_WIDTH-1:0] acc12;
    logic [ACC_WIDTH-1:0] acc13;

    logic [ACC_WIDTH-1:0] acc20;
    logic [ACC_WIDTH-1:0] acc21;
    logic [ACC_WIDTH-1:0] acc22;
    logic [ACC_WIDTH-1:0] acc23;

    logic [ACC_WIDTH-1:0] acc30;
    logic [ACC_WIDTH-1:0] acc31;
    logic [ACC_WIDTH-1:0] acc32;
    logic [ACC_WIDTH-1:0] acc33;

    logic [7:0] c_addr;
    logic [ACC_WIDTH-1:0] c_write_data;

    tile_controller controller (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),

        .clear_array(clear_array),
        .enable_array(enable_array),
        .save_result(save_result),

        .busy(busy),
        .done(done),

        .tile_row(tile_row),
        .tile_col(tile_col),
        .k_tile(k_tile),

        .cycle_count(cycle_count),
        .save_index(save_index)
    );

    pe_array_4x4 #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) array (
        .clk(clk),
        .rst_n(rst_n),
        .clear(clear_array),
        .enable(enable_array),

        .a_row0(a_row0),
        .a_row1(a_row1),
        .a_row2(a_row2),
        .a_row3(a_row3),

        .b_col0(b_col0),
        .b_col1(b_col1),
        .b_col2(b_col2),
        .b_col3(b_col3),

        .acc00(acc00),
        .acc01(acc01),
        .acc02(acc02),
        .acc03(acc03),

        .acc10(acc10),
        .acc11(acc11),
        .acc12(acc12),
        .acc13(acc13),

        .acc20(acc20),
        .acc21(acc21),
        .acc22(acc22),
        .acc23(acc23),

        .acc30(acc30),
        .acc31(acc31),
        .acc32(acc32),
        .acc33(acc33)
    );

    always_ff @(posedge clk) begin
        if (load_we && !busy) begin
            if (load_b)
                b_mem[{load_row, load_col}] <= load_data;
            else
                a_mem[{load_row, load_col}] <= load_data;
        end
    end

    always_comb begin
        case (save_index)
            4'd0:  c_write_data = acc00;
            4'd1:  c_write_data = acc01;
            4'd2:  c_write_data = acc02;
            4'd3:  c_write_data = acc03;

            4'd4:  c_write_data = acc10;
            4'd5:  c_write_data = acc11;
            4'd6:  c_write_data = acc12;
            4'd7:  c_write_data = acc13;

            4'd8:  c_write_data = acc20;
            4'd9:  c_write_data = acc21;
            4'd10: c_write_data = acc22;
            4'd11: c_write_data = acc23;

            4'd12: c_write_data = acc30;
            4'd13: c_write_data = acc31;
            4'd14: c_write_data = acc32;
            4'd15: c_write_data = acc33;

            default: c_write_data = '0;
        endcase
    end

    always_comb begin
        if (save_result) begin
            c_addr = {
                tile_row,
                save_index[3:2],
                tile_col,
                save_index[1:0]
            };
        end else begin
            c_addr = {result_row, result_col};
        end
    end

    always_ff @(posedge clk) begin
        if (save_result)
            c_mem[c_addr] <= c_write_data;
        else
            result_data <= c_mem[c_addr];
    end

    always_comb begin
        a_row0 = '0;
        a_row1 = '0;
        a_row2 = '0;
        a_row3 = '0;

        b_col0 = '0;
        b_col1 = '0;
        b_col2 = '0;
        b_col3 = '0;

        if (enable_array) begin

            case (cycle_count)

                4'd0: begin
                    a_row0 =
                        a_mem[{tile_row, 2'd0, k_tile, 2'd0}];

                    b_col0 =
                        b_mem[{k_tile, 2'd0, tile_col, 2'd0}];
                end

                4'd1: begin
                    a_row0 =
                        a_mem[{tile_row, 2'd0, k_tile, 2'd1}];

                    a_row1 =
                        a_mem[{tile_row, 2'd1, k_tile, 2'd0}];

                    b_col0 =
                        b_mem[{k_tile, 2'd1, tile_col, 2'd0}];

                    b_col1 =
                        b_mem[{k_tile, 2'd0, tile_col, 2'd1}];
                end

                4'd2: begin
                    a_row0 =
                        a_mem[{tile_row, 2'd0, k_tile, 2'd2}];

                    a_row1 =
                        a_mem[{tile_row, 2'd1, k_tile, 2'd1}];

                    a_row2 =
                        a_mem[{tile_row, 2'd2, k_tile, 2'd0}];

                    b_col0 =
                        b_mem[{k_tile, 2'd2, tile_col, 2'd0}];

                    b_col1 =
                        b_mem[{k_tile, 2'd1, tile_col, 2'd1}];

                    b_col2 =
                        b_mem[{k_tile, 2'd0, tile_col, 2'd2}];
                end

                4'd3: begin
                    a_row0 =
                        a_mem[{tile_row, 2'd0, k_tile, 2'd3}];

                    a_row1 =
                        a_mem[{tile_row, 2'd1, k_tile, 2'd2}];

                    a_row2 =
                        a_mem[{tile_row, 2'd2, k_tile, 2'd1}];

                    a_row3 =
                        a_mem[{tile_row, 2'd3, k_tile, 2'd0}];

                    b_col0 =
                        b_mem[{k_tile, 2'd3, tile_col, 2'd0}];

                    b_col1 =
                        b_mem[{k_tile, 2'd2, tile_col, 2'd1}];

                    b_col2 =
                        b_mem[{k_tile, 2'd1, tile_col, 2'd2}];

                    b_col3 =
                        b_mem[{k_tile, 2'd0, tile_col, 2'd3}];
                end

                4'd4: begin
                    a_row1 =
                        a_mem[{tile_row, 2'd1, k_tile, 2'd3}];

                    a_row2 =
                        a_mem[{tile_row, 2'd2, k_tile, 2'd2}];

                    a_row3 =
                        a_mem[{tile_row, 2'd3, k_tile, 2'd1}];

                    b_col1 =
                        b_mem[{k_tile, 2'd3, tile_col, 2'd1}];

                    b_col2 =
                        b_mem[{k_tile, 2'd2, tile_col, 2'd2}];

                    b_col3 =
                        b_mem[{k_tile, 2'd1, tile_col, 2'd3}];
                end

                4'd5: begin
                    a_row2 =
                        a_mem[{tile_row, 2'd2, k_tile, 2'd3}];

                    a_row3 =
                        a_mem[{tile_row, 2'd3, k_tile, 2'd2}];

                    b_col2 =
                        b_mem[{k_tile, 2'd3, tile_col, 2'd2}];

                    b_col3 =
                        b_mem[{k_tile, 2'd2, tile_col, 2'd3}];
                end

                4'd6: begin
                    a_row3 =
                        a_mem[{tile_row, 2'd3, k_tile, 2'd3}];

                    b_col3 =
                        b_mem[{k_tile, 2'd3, tile_col, 2'd3}];
                end

                default: begin
                end

            endcase
        end
    end
    
endmodule
