module tb_matmul_16x16;

    logic clk;
    logic rst_n;
    logic start;

    logic load_we;
    logic load_b;
    logic [3:0] load_row;
    logic [3:0] load_col;
    logic [7:0] load_data;

    logic [3:0] result_row;
    logic [3:0] result_col;
    logic [31:0] result_data;

    logic busy;
    logic done;

    integer r;
    integer c;
    integer errors;
    integer expected;

    matmul_16x16 dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),

        .load_we(load_we),
        .load_b(load_b),
        .load_row(load_row),
        .load_col(load_col),
        .load_data(load_data),

        .result_row(result_row),
        .result_col(result_col),
        .result_data(result_data),

        .busy(busy),
        .done(done)
    );

    initial clk = 0;
    always #5 clk <= ~clk;

    task load_value(
        input logic is_b,
        input logic [3:0] row,
        input logic [3:0] col,
        input logic [7:0] data
    );
    begin
        @(negedge clk);

        load_b    = is_b;
        load_row  = row;
        load_col  = col;
        load_data = data;
        load_we   = 1;

        @(negedge clk);

        load_we = 0;
    end
    endtask

    initial begin

        rst_n = 0;
        start = 0;

        load_we   = 0;
        load_b    = 0;
        load_row  = 0;
        load_col  = 0;
        load_data = 0;

        result_row = 0;
        result_col = 0;

        errors = 0;

        repeat (2) @(posedge clk);
        rst_n = 1;

        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                load_value(
                    1'b0,
                    r[3:0],
                    c[3:0],
                    8'(r + c + 1)
                );
            end
        end

        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                load_value(
                    1'b1,
                    r[3:0],
                    c[3:0],
                    8'd1
                );
            end
        end

        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;

        wait(busy == 1'b1);
        wait(done == 1'b1);

        #1;

        for (r = 0; r < 16; r = r + 1) begin

            expected = (16 * r) + 136;

            for (c = 0; c < 16; c = c + 1) begin

                result_row = r[3:0];
                result_col = c[3:0];

                #1;

                if (result_data !== expected) begin
                    $display(
                        "FAIL C[%0d][%0d] expected=%0d got=%0d",
                        r,
                        c,
                        expected,
                        result_data
                    );

                    errors = errors + 1;
                end

            end
        end

        if (errors == 0) begin
            $display("16x16 MATRIX MULTIPLY TEST PASS");
            $display("All 256 outputs correct");
        end else begin
            $display(
                "16x16 MATRIX MULTIPLY TEST FAILED: %0d errors",
                errors
            );
        end

        $finish;

    end

endmodule
