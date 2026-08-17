module tb_mac;

    logic clk;
    logic rst_n;
    logic clear;
    logic enable;
    logic [7:0] a;
    logic [7:0] b;
    logic [31:0] acc;

    mac dut (
        .clk(clk),
        .rst_n(rst_n),
        .clear(clear),
        .enable(enable),
        .a(a),
        .b(b),
        .acc(acc)
    );
    initial clk = 0;
    always #5 clk <= ~clk;

 initial begin
    rst_n  = 0;
    clear  = 0;
    enable = 0;
    a      = 0;
    b      = 0;

    #10;

//Reset Test
    rst_n = 1;

    #1;

    if (acc == 0)
        $display("RESET TEST PASS");
    else
        $display("RESET TEST FAIL: acc = %0d", acc);
    
    #1


//Multiply Test
   a      = 4;
   b      = 3;
   enable = 1;
   
   @(posedge clk);
   #1;

if (acc == 12)
    $display("MULTIPLY TEST PASS");
else
    $display("MULTIPLY TEST FAIL: acc = %0d", acc);


// Accumulate Test
a = 2;
b = 5;

@(posedge clk);
#1;

if (acc == 22)
    $display("ACCUMULATE TEST PASS");
else
    $display("ACCUMULATE TEST FAIL: acc = %0d", acc);


// Clear Test
clear = 1;

@(posedge clk);
#1;

if (acc == 0)
    $display("CLEAR TEST PASS");
else
    $display("CLEAR TEST FAIL: acc = %0d", acc);

clear = 0;


// Enable Hold Test
enable = 0;
a = 7;
b = 9;

@(posedge clk);
#1;

if (acc == 0)
    $display("HOLD TEST PASS");
else
    $display("HOLD TEST FAIL: acc = %0d", acc);

$finish;

end

endmodule
