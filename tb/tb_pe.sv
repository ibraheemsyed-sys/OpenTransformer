module tb_pe;

    logic clk;
    logic rst_n;
    logic clear;
    logic enable;

    logic [7:0]  a_in;
    logic [7:0]  b_in;
    logic [7:0]  a_out;
    logic [7:0]  b_out;
    logic [31:0] acc;

    pe dut (
        .clk(clk),
        .rst_n(rst_n),
        .clear(clear),
        .enable(enable),
        .a_in(a_in),
        .b_in(b_in),
        .a_out(a_out),
        .b_out(b_out),
        .acc(acc)
    );

    initial clk = 0;
    always #5 clk <= ~clk;

    initial begin
        rst_n = 0;
        clear  = 0;
        enable = 0;
        a_in   = 0;
        b_in   = 0;

        #10;
        rst_n = 1;

        a_in   = 4;
        b_in   = 3;
        enable = 1;

        @(posedge clk);
        #1;

        if ((a_out == 4) && (b_out == 3) && (acc == 12))
        
        $display("PE COMPUTE/FORWARD TEST PASS");

        else

        $display("PE COMPUTE/FORWARD TEST FAILED: a_out=%0d b_out=%0d acc=%0d",
        a_out, b_out, acc);

        a_in = 2;
        b_in = 5;

        @(posedge clk);
        #1;

        if ((a_out == 2) && (b_out == 5) && (acc == 22))
        $display("PE ACCUMULATE TEST PASS");
        else
        $display("PE ACCUMULATE TEST FAILED: a_out=%0d b_out=%0d acc=%0d",
        a_out, b_out, acc);

        // Clear accumulator
        clear = 1;

        @(posedge clk);
        #1;

        if (acc == 0)
        $display("PE CLEAR TEST PASS");
        else
        $display("PE CLEAR TEST FAILED: acc=%0d", acc);

        clear = 0;

        // Hold test
        enable = 0;
        a_in = 7;
        b_in = 9;

        @(posedge clk);
        #1;

        if ((a_out == 2) && (b_out == 5) && (acc == 0))
        $display("PE HOLD TEST PASS");
        else
        $display("PE HOLD TEST FAILED: a_out=%0d b_out=%0d acc=%0d",
             a_out, b_out, acc);


        $finish;
    end

endmodule
