/* verilator lint_off DECLFILENAME */

module fpga_top (
    input  logic clk,
    input  logic rst_n,
    input  logic uart_rx,
    output logic uart_tx
);

    logic [7:0] rx_data;
    logic rx_valid;

    logic [7:0] tx_data;
    logic tx_start;
    logic tx_busy;

    logic start;
    logic load_we;
    logic load_b;

    logic [3:0] load_row;
    logic [3:0] load_col;
    logic [7:0] load_data;

    logic [3:0] result_row;
    logic [3:0] result_col;
    logic [31:0] result_data;

    logic engine_busy;
    logic done;

    logic [7:0] rx_index;
    logic [7:0] result_index;

    logic [1:0] byte_index;
    logic [31:0] result_latched;

    typedef enum logic [3:0] {
        WAIT_HEADER,
        LOAD_A,
        LOAD_B,
        START_ENGINE,
        WAIT_ENGINE,
        SEND_HEADER,
        WAIT_HEADER_TX,
        WAIT_RESULT_READ,
        LATCH_RESULT,
        SEND_RESULT,
        WAIT_RESULT_TX
    } state_t;

    state_t state;

    uart_rx_byte rx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rx(uart_rx),
        .data(rx_data),
        .valid(rx_valid)
    );

    uart_tx_byte tx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .start(tx_start),
        .data(tx_data),
        .tx(uart_tx),
        .busy(tx_busy)
    );

    matmul_16x16 engine (
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

        .busy(engine_busy),
        .done(done)
    );

    assign result_row = result_index[7:4];
    assign result_col = result_index[3:0];

    always_comb begin
        start = 1'b0;

        load_we   = 1'b0;
        load_b    = 1'b0;

        load_row  = rx_index[7:4];
        load_col  = rx_index[3:0];
        load_data = rx_data;

        case (state)

            LOAD_A: begin
                if (rx_valid) begin
                    load_we = 1'b1;
                    load_b  = 1'b0;
                end
            end

            LOAD_B: begin
                if (rx_valid) begin
                    load_we = 1'b1;
                    load_b  = 1'b1;
                end
            end

            START_ENGINE: begin
                start = 1'b1;
            end

            default: begin
            end

        endcase
    end

    always_comb begin
        tx_start = 1'b0;
        tx_data  = 8'h00;

        if ((state == SEND_HEADER) && !tx_busy) begin
            tx_start = 1'b1;
            tx_data  = 8'h5A;
        end

        if ((state == SEND_RESULT) && !tx_busy) begin
            tx_start = 1'b1;

            case (byte_index)
                2'd0: tx_data = result_latched[7:0];
                2'd1: tx_data = result_latched[15:8];
                2'd2: tx_data = result_latched[23:16];
                2'd3: tx_data = result_latched[31:24];

                default: tx_data = 8'h00;
            endcase
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= WAIT_HEADER;
            rx_index       <= 8'd0;
            result_index   <= 8'd0;
            byte_index     <= 2'd0;
            result_latched <= 32'd0;
        end else begin

            case (state)

                WAIT_HEADER: begin
                    if (rx_valid && (rx_data == 8'hA5)) begin
                        rx_index <= 8'd0;
                        state <= LOAD_A;
                    end
                end

                LOAD_A: begin
                    if (rx_valid) begin
                        if (rx_index == 8'hFF) begin
                            rx_index <= 8'd0;
                            state <= LOAD_B;
                        end else begin
                            rx_index <= rx_index + 8'd1;
                        end
                    end
                end

                LOAD_B: begin
                    if (rx_valid) begin
                        if (rx_index == 8'hFF) begin
                            rx_index <= 8'd0;
                            state <= START_ENGINE;
                        end else begin
                            rx_index <= rx_index + 8'd1;
                        end
                    end
                end

                START_ENGINE: begin
                    state <= WAIT_ENGINE;
                end

                WAIT_ENGINE: begin
                    if (done && !engine_busy) begin
                        result_index <= 8'd0;
                        state <= SEND_HEADER;
                    end
                end

                SEND_HEADER: begin
                    if (!tx_busy)
                        state <= WAIT_HEADER_TX;
                end

                WAIT_HEADER_TX: begin
                    if (!tx_busy)
                        state <= WAIT_RESULT_READ;
                end

                WAIT_RESULT_READ: begin
                    state <= LATCH_RESULT;
                end

                LATCH_RESULT: begin
                    result_latched <= result_data;
                    byte_index <= 2'd0;
                    state <= SEND_RESULT;
                end

                SEND_RESULT: begin
                    if (!tx_busy)
                        state <= WAIT_RESULT_TX;
                end

                WAIT_RESULT_TX: begin
                    if (!tx_busy) begin

                        if (byte_index == 2'd3) begin

                            if (result_index == 8'hFF) begin
                                state <= WAIT_HEADER;
                            end else begin
                                result_index <= result_index + 8'd1;
                                state <= WAIT_RESULT_READ;
                            end

                        end else begin
                            byte_index <= byte_index + 2'd1;
                            state <= SEND_RESULT;
                        end

                    end
                end

                default: begin
                    state <= WAIT_HEADER;
                end

            endcase
        end
    end

endmodule


module uart_rx_byte (
    input  logic clk,
    input  logic rst_n,
    input  logic rx,

    output logic [7:0] data,
    output logic valid
);

    localparam logic [7:0] CLKS_PER_BIT = 8'd234;
    localparam logic [7:0] HALF_BIT     = 8'd117;

    typedef enum logic [1:0] {
        RX_IDLE,
        RX_START,
        RX_DATA,
        RX_STOP
    } rx_state_t;

    rx_state_t state;

    logic rx_meta;
    logic rx_sync;

    logic [7:0] clk_count;
    logic [2:0] bit_index;
    logic [7:0] shift_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_meta <= 1'b1;
            rx_sync <= 1'b1;
        end else begin
            rx_meta <= rx;
            rx_sync <= rx_meta;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= RX_IDLE;
            clk_count <= 8'd0;
            bit_index <= 3'd0;
            shift_reg <= 8'd0;
            data      <= 8'd0;
            valid     <= 1'b0;
        end else begin

            valid <= 1'b0;

            case (state)

                RX_IDLE: begin
                    clk_count <= 8'd0;
                    bit_index <= 3'd0;

                    if (!rx_sync)
                        state <= RX_START;
                end

                RX_START: begin
                    if (clk_count == (HALF_BIT - 8'd1)) begin
                        clk_count <= 8'd0;

                        if (!rx_sync)
                            state <= RX_DATA;
                        else
                            state <= RX_IDLE;
                    end else begin
                        clk_count <= clk_count + 8'd1;
                    end
                end

                RX_DATA: begin
                    if (clk_count == (CLKS_PER_BIT - 8'd1)) begin
                        clk_count <= 8'd0;
                        shift_reg[bit_index] <= rx_sync;

                        if (bit_index == 3'd7) begin
                            bit_index <= 3'd0;
                            state <= RX_STOP;
                        end else begin
                            bit_index <= bit_index + 3'd1;
                        end
                    end else begin
                        clk_count <= clk_count + 8'd1;
                    end
                end

                RX_STOP: begin
                    if (clk_count == (CLKS_PER_BIT - 8'd1)) begin
                        clk_count <= 8'd0;

                        if (rx_sync) begin
                            data <= shift_reg;
                            valid <= 1'b1;
                        end

                        state <= RX_IDLE;
                    end else begin
                        clk_count <= clk_count + 8'd1;
                    end
                end

                default: begin
                    state <= RX_IDLE;
                end

            endcase
        end
    end

endmodule


module uart_tx_byte (
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    input  logic [7:0] data,

    output logic tx,
    output logic busy
);

    localparam logic [7:0] CLKS_PER_BIT = 8'd234;

    typedef enum logic [1:0] {
        TX_IDLE,
        TX_START_BIT,
        TX_DATA_BITS,
        TX_STOP_BIT
    } tx_state_t;

    tx_state_t state;

    logic [7:0] clk_count;
    logic [2:0] bit_index;
    logic [7:0] data_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= TX_IDLE;
            clk_count <= 8'd0;
            bit_index <= 3'd0;
            data_reg  <= 8'd0;
            tx         <= 1'b1;
            busy       <= 1'b0;
        end else begin

            case (state)

                TX_IDLE: begin
                    tx        <= 1'b1;
                    busy      <= 1'b0;
                    clk_count <= 8'd0;

                    if (start) begin
                        data_reg  <= data;
                        bit_index <= 3'd0;
                        tx        <= 1'b0;
                        busy      <= 1'b1;
                        state     <= TX_START_BIT;
                    end
                end

                TX_START_BIT: begin
                    busy <= 1'b1;

                    if (clk_count == (CLKS_PER_BIT - 8'd1)) begin
                        clk_count <= 8'd0;
                        tx <= data_reg[0];
                        state <= TX_DATA_BITS;
                    end else begin
                        clk_count <= clk_count + 8'd1;
                    end
                end

                TX_DATA_BITS: begin
                    busy <= 1'b1;

                    if (clk_count == (CLKS_PER_BIT - 8'd1)) begin
                        clk_count <= 8'd0;

                        if (bit_index == 3'd7) begin
                            tx <= 1'b1;
                            state <= TX_STOP_BIT;
                        end else begin
                            bit_index <= bit_index + 3'd1;
                            tx <= data_reg[bit_index + 3'd1];
                        end
                    end else begin
                        clk_count <= clk_count + 8'd1;
                    end
                end

                TX_STOP_BIT: begin
                    busy <= 1'b1;

                    if (clk_count == (CLKS_PER_BIT - 8'd1)) begin
                        clk_count <= 8'd0;
                        tx <= 1'b1;
                        busy <= 1'b0;
                        state <= TX_IDLE;
                    end else begin
                        clk_count <= clk_count + 8'd1;
                    end
                end

                default: begin
                    state <= TX_IDLE;
                    tx <= 1'b1;
                    busy <= 1'b0;
                end

            endcase
        end
    end

endmodule

/* verilator lint_on DECLFILENAME */
