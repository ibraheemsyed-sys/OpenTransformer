module tb_pe_array_2x2;

    logic clk;
    logic rst_n;
    logic clear;
    logic enable;

    logic [7:0] a_row0;
    logic [7:0] a_row1;
    logic [7:0] b_col0;
    logic [7:0] b_col1;

    logic [7:0] a_right0;
    logic [7:0] a_right1;
    logic [7:0] b_bottom0;
    logic [7:0] b_bottom1;

    logic [31:0] acc00;
    logic [31:0] acc01;
    logic [31:0] acc10;
    logic [31:0] acc11;

    pe_array_2x2 dut (
        .clk(clk),
        .rst_n(rst_n),
        .clear(clear),
        .enable(enable),

        .a_row0(a_row0),
        .a_row1(a_row1),
        .b_col0(b_col0),
        .b_col1(b_col1),

        .a_right0(a_right0),
        .a_right1(a_right1),
        .b_bottom0(b_bottom0),
        .b_bottom1(b_bottom1),

        .acc00(acc00),
        .acc01(acc01),
        .acc10(acc10),
        .acc11(acc11)
    );

    initial clk = 0;
    always #5 clk <= ~clk;

    initial begin

        // Initial values
        rst_n  = 0;
        clear  = 0;
        enable = 0;

        a_row0 = 0;
        a_row1 = 0;
        b_col0 = 0;
        b_col1 = 0;

        // Reset
        #12;
        rst_n  = 1;
        enable = 1;

        // --------------------------------
        // Matrix A
        //
        // [ 1  2 ]
        // [ 3  4 ]
        //
        // Matrix B
        //
        // [ 5  6 ]
        // [ 7  8 ]
        //
        // Expected:
        //
        // [ 19  22 ]
        // [ 43  50 ]
        // --------------------------------


        // Cycle 1
        a_row0 = 1;
        a_row1 = 0;

        b_col0 = 5;
        b_col1 = 0;

        @(posedge clk);
        #1;


        // Cycle 2
        a_row0 = 2;
        a_row1 = 3;

        b_col0 = 7;
        b_col1 = 6;

        @(posedge clk);
        #1;


        // Cycle 3
        a_row0 = 0;
        a_row1 = 4;

        b_col0 = 0;
        b_col1 = 8;

        @(posedge clk);
        #1;


        // Cycle 4 - Flush final values through array
        a_row0 = 0;
        a_row1 = 0;

        b_col0 = 0;
        b_col1 = 0;

        @(posedge clk);
        #1;


        // Check matrix multiplication result
        if (
            (acc00 == 19) &&
            (acc01 == 22) &&
            (acc10 == 43) &&
            (acc11 == 50)
        )
            $display("2x2 MATRIX MULTIPLY TEST PASS");
        else begin
            $display("2x2 MATRIX MULTIPLY TEST FAILED");
            $display("Expected: [19 22; 43 50]");
            $display("Got:      [%0d %0d; %0d %0d]",
                     acc00, acc01, acc10, acc11);
        end


        // Display edge outputs so they are also exercised
        $display(
            "Edge outputs: a_right0=%0d a_right1=%0d b_bottom0=%0d b_bottom1=%0d",
            a_right0, a_right1, b_bottom0, b_bottom1
        );


        // Clear test
        clear = 1;

        @(posedge clk);
        #1;

        if (
            (acc00 == 0) &&
            (acc01 == 0) &&
            (acc10 == 0) &&
            (acc11 == 0)
        )
            $display("2x2 ARRAY CLEAR TEST PASS");
        else
            $display(
                "2x2 ARRAY CLEAR TEST FAILED: [%0d %0d; %0d %0d]",
                acc00, acc01, acc10, acc11
            );

        clear = 0;


        $finish;

    end

endmodule
