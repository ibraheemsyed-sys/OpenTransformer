module tb_pe_array_4x4;

    logic clk;
    logic rst_n;
    logic clear;
    logic enable;

    logic [7:0] a_row0;
    logic [7:0] a_row1;
    logic [7:0] a_row2;
    logic [7:0] a_row3;

    logic [7:0] b_col0;
    logic [7:0] b_col1;
    logic [7:0] b_col2;
    logic [7:0] b_col3;

    logic [31:0] acc00;
    logic [31:0] acc01;
    logic [31:0] acc02;
    logic [31:0] acc03;

    logic [31:0] acc10;
    logic [31:0] acc11;
    logic [31:0] acc12;
    logic [31:0] acc13;

    logic [31:0] acc20;
    logic [31:0] acc21;
    logic [31:0] acc22;
    logic [31:0] acc23;

    logic [31:0] acc30;
    logic [31:0] acc31;
    logic [31:0] acc32;
    logic [31:0] acc33;


    pe_array_4x4 dut (
        .clk(clk),
        .rst_n(rst_n),
        .clear(clear),
        .enable(enable),

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


    // Clock
    initial clk = 0;
    always #5 clk <= ~clk;


    // Drive one systolic-array cycle
    task drive_cycle(
        input [7:0] ar0,
        input [7:0] ar1,
        input [7:0] ar2,
        input [7:0] ar3,

        input [7:0] bc0,
        input [7:0] bc1,
        input [7:0] bc2,
        input [7:0] bc3
    );
    begin

        a_row0 = ar0;
        a_row1 = ar1;
        a_row2 = ar2;
        a_row3 = ar3;

        b_col0 = bc0;
        b_col1 = bc1;
        b_col2 = bc2;
        b_col3 = bc3;

        @(posedge clk);
        #1;

    end
    endtask


    initial begin

        rst_n  = 0;
        clear  = 0;
        enable = 0;

        a_row0 = 0;
        a_row1 = 0;
        a_row2 = 0;
        a_row3 = 0;

        b_col0 = 0;
        b_col1 = 0;
        b_col2 = 0;
        b_col3 = 0;


        // Reset
        #12;
        rst_n  = 1;
        enable = 1;


        // Matrix A
        // [  1   2   3   4 ]
        // [  5   6   7   8 ]
        // [  9  10  11  12 ]
        // [ 13  14  15  16 ]

        // Matrix B = Identity
        // [ 1 0 0 0 ]
        // [ 0 1 0 0 ]
        // [ 0 0 1 0 ]
        // [ 0 0 0 1 ]

        // Expected:
        // C = A


        // Cycle 0
        drive_cycle(
            1, 0, 0, 0,
            1, 0, 0, 0
        );


        // Cycle 1
        drive_cycle(
            2, 5, 0, 0,
            0, 0, 0, 0
        );


        // Cycle 2
        drive_cycle(
            3, 6, 9, 0,
            0, 1, 0, 0
        );


        // Cycle 3
        drive_cycle(
            4, 7, 10, 13,
            0, 0, 0, 0
        );


        // Cycle 4
        drive_cycle(
            0, 8, 11, 14,
            0, 0, 1, 0
        );


        // Cycle 5
        drive_cycle(
            0, 0, 12, 15,
            0, 0, 0, 0
        );


        // Cycle 6
        drive_cycle(
            0, 0, 0, 16,
            0, 0, 0, 1
        );


        // Flush remaining data through array
        drive_cycle(0,0,0,0, 0,0,0,0);
        drive_cycle(0,0,0,0, 0,0,0,0);
        drive_cycle(0,0,0,0, 0,0,0,0);


        // Check result

        if (
            (acc00 == 1)  &&
            (acc01 == 2)  &&
            (acc02 == 3)  &&
            (acc03 == 4)  &&

            (acc10 == 5)  &&
            (acc11 == 6)  &&
            (acc12 == 7)  &&
            (acc13 == 8)  &&

            (acc20 == 9)  &&
            (acc21 == 10) &&
            (acc22 == 11) &&
            (acc23 == 12) &&

            (acc30 == 13) &&
            (acc31 == 14) &&
            (acc32 == 15) &&
            (acc33 == 16)
        )

        begin
            $display("4x4 MATRIX MULTIPLY TEST PASS");

            $display(
                "[%0d %0d %0d %0d]",
                acc00, acc01, acc02, acc03
            );

            $display(
                "[%0d %0d %0d %0d]",
                acc10, acc11, acc12, acc13
            );

            $display(
                "[%0d %0d %0d %0d]",
                acc20, acc21, acc22, acc23
            );

            $display(
                "[%0d %0d %0d %0d]",
                acc30, acc31, acc32, acc33
            );
        end

        else begin

            $display("4x4 MATRIX MULTIPLY TEST FAILED");

            $display("Expected:");

            $display("[1  2  3  4]");
            $display("[5  6  7  8]");
            $display("[9 10 11 12]");
            $display("[13 14 15 16]");

            $display("Got:");

            $display(
                "[%0d %0d %0d %0d]",
                acc00, acc01, acc02, acc03
            );

            $display(
                "[%0d %0d %0d %0d]",
                acc10, acc11, acc12, acc13
            );

            $display(
                "[%0d %0d %0d %0d]",
                acc20, acc21, acc22, acc23
            );

            $display(
                "[%0d %0d %0d %0d]",
                acc30, acc31, acc32, acc33
            );

        end


        // Clear test

        clear = 1;

        @(posedge clk);
        #1;

        if (
            (acc00 == 0) &&
            (acc01 == 0) &&
            (acc02 == 0) &&
            (acc03 == 0) &&

            (acc10 == 0) &&
            (acc11 == 0) &&
            (acc12 == 0) &&
            (acc13 == 0) &&

            (acc20 == 0) &&
            (acc21 == 0) &&
            (acc22 == 0) &&
            (acc23 == 0) &&

            (acc30 == 0) &&
            (acc31 == 0) &&
            (acc32 == 0) &&
            (acc33 == 0)
        )
            $display("4x4 ARRAY CLEAR TEST PASS");
        else
            $display("4x4 ARRAY CLEAR TEST FAILED");


        clear = 0;

        $finish;

    end

endmodule
