module tb_reg_file;

    // Signal Declarations
    logic       clk;       // Clock signal
    logic       rst_n;     // Active-low reset signal
    
    // Write Port Signals
    logic       w_en;      // Write enable control signal
    logic [3:0] w_addr;    // Write target address (0 to 15)
    logic [7:0] w_data;    // 8-bit data to write
    
    // Read Port Signals
    logic [3:0] r_addr_a;  // Read Port A target address
    logic [3:0] r_addr_b;  // Read Port B target address
    logic [7:0] r_data_a;  // 8-bit output data from Port A
    logic [7:0] r_data_b;  // 8-bit output data from Port B

    // Clock Generator: 10ns period (100 MHz)
    always #5 clk = ~clk;

    // Design Under Test (DUT) Instantiation
    reg_file dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .w_en     (w_en),
        .w_addr   (w_addr),
        .w_data   (w_data),
        .r_addr_a (r_addr_a),
        .r_addr_b (r_addr_b),
        .r_data_a (r_data_a),
        .r_data_b (r_data_b)
    );

    // Main Testing Sequence
    initial begin
        // Waveform Dump Configuration
        $dumpfile("reg_file.vcd");
        $dumpvars(0, tb_reg_file);

        // Signal Initialization
        clk      = 0;
        rst_n    = 0;  // Assert reset initially
        w_en     = 0;
        w_addr   = 0;
        w_data   = 0;
        r_addr_a = 0;
        r_addr_b = 0;

        // Reset Pulse Sequence
        #10;
        rst_n = 1;     // De-assert reset to activate memory
        #5;

        // -----------------------------------------------------
        // TEST 1: Write and Read Port A
        // -----------------------------------------------------
        $display("\n=================== TEST 1 ===================");
        $display("Time | w_addr | w_data | w_en | r_addr_a | r_data_a");
        $display("-----------------------------------------------------");

        // Write Step: Write 0xA5 into Register 4
        @(posedge clk);
        w_en   = 1;
        w_addr = 4'd4;
        w_data = 8'hA5;
        
        @(posedge clk);
        // Read Step: Turn off write enable and read from Register 4
        w_en     = 0;
        r_addr_a = 4'd4;
        #1; // Brief delay to sample output after clock edge
        
        $display("%0t    | %d      | %h     | %b    | %d        | %h", 
                 $time, w_addr, w_data, w_en, r_addr_a, r_data_a);

        // -----------------------------------------------------
        // TEST 2: Write and Read Port B
        // -----------------------------------------------------
        $display("\n=================== TEST 2 ===================");
        $display("Time | w_addr | w_data | w_en | r_addr_b | r_data_b");
        $display("-----------------------------------------------------");

        // Write Step: Write 0xA6 into Register 5
        @(posedge clk);
        w_en   = 1;
        w_addr = 4'd5;
        w_data = 8'hA6;
        
        @(posedge clk);
        // Read Step: Turn off write enable and read from Register 5 via Port B
        w_en     = 0;
        r_addr_b = 4'd5;
        #1; // Brief delay to sample output after clock edge
        
        $display("%0t   | %d      | %h     | %b    | %d        | %h", 
                 $time, w_addr, w_data, w_en, r_addr_b, r_data_b);

        // End Simulation
        #10;
        $finish;
    end

endmodule