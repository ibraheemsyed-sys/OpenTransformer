module reg_file (
    // Needed
    input logic clk,      // Clock
    input logic rst_n,    // Reset Button
    // Write
    input  logic       w_en,   // Write permission switch
    input  logic [3:0] w_addr, // Which box to write into (0 to 15)
    input  logic [7:0] w_data, // The 8-bit data to save
    // Read
    input  logic [3:0] r_addr_a, // Which box to read from (1/2)
    input  logic [3:0] r_addr_b, // Which box to read from (2/2)
    output logic [7:0] r_data_a, // 8-bit data output (1/2)
    output logic [7:0] r_data_b  // 8-bit data output (2/2)
);

    // 2. THE INTERNAL STORAGE 
    logic [7:0] registers [16];

    // 3. READ LOGIC (Instant/Asynchronous)
    assign r_data_a = registers[r_addr_a];
    assign r_data_b = registers[r_addr_b];

    // 3. WRITE & RESET LOGIC (Synchronous)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset: Clear all 16 boxes to 0
            for (int i = 0; i < 16; i++) begin
                registers[i] <= 8'h0;
            end
        end else if (w_en) begin
            // Write: Save data if w_en is high
            registers[w_addr] <= w_data;
        end
    end

endmodule