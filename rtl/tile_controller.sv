module tile_controller (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       start,

    output logic       clear_array,
    output logic       enable_array,
    output logic       save_result,
    output logic       busy,
    output logic       done,

    output logic [1:0] tile_row,
    output logic [1:0] tile_col,
    output logic [1:0] k_tile,
    output logic [3:0] cycle_count,
    output logic [3:0] save_index
);

    typedef enum logic [2:0] {
        IDLE,
        CLEAR,
        RUN,
        SAVE,
        DONE
    } state_t;

    state_t state;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            tile_row    <= 2'd0;
            tile_col    <= 2'd0;
            k_tile      <= 2'd0;
            cycle_count <= 4'd0;
            save_index  <= 4'd0;
        end else begin

            case (state)

                IDLE: begin
                    tile_row    <= 2'd0;
                    tile_col    <= 2'd0;
                    k_tile      <= 2'd0;
                    cycle_count <= 4'd0;
                    save_index  <= 4'd0;

                    if (start)
                        state <= CLEAR;
                end

                CLEAR: begin
                    cycle_count <= 4'd0;
                    save_index  <= 4'd0;
                    state       <= RUN;
                end

                RUN: begin
                    if (cycle_count == 4'd9) begin
                        cycle_count <= 4'd0;

                        if (k_tile == 2'd3) begin
                            save_index <= 4'd0;
                            state <= SAVE;
                        end else begin
                            k_tile <= k_tile + 2'd1;
                        end
                    end else begin
                        cycle_count <= cycle_count + 4'd1;
                    end
                end

                SAVE: begin
                    if (save_index == 4'd15) begin
                        save_index <= 4'd0;
                        k_tile <= 2'd0;

                        if ((tile_row == 2'd3) &&
                            (tile_col == 2'd3)) begin
                            state <= DONE;
                        end else begin

                            if (tile_col == 2'd3) begin
                                tile_col <= 2'd0;
                                tile_row <= tile_row + 2'd1;
                            end else begin
                                tile_col <= tile_col + 2'd1;
                            end

                            state <= CLEAR;
                        end

                    end else begin
                        save_index <= save_index + 4'd1;
                    end
                end

                DONE: begin
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end

    always_comb begin
        clear_array  = 1'b0;
        enable_array = 1'b0;
        save_result  = 1'b0;
        busy         = 1'b0;
        done         = 1'b0;

        case (state)

            CLEAR: begin
                busy = 1'b1;
                clear_array = 1'b1;
            end

            RUN: begin
                busy = 1'b1;
                enable_array = 1'b1;
            end

            SAVE: begin
                busy = 1'b1;
                save_result = 1'b1;
            end

            DONE: begin
                done = 1'b1;
            end

            default: begin
            end

        endcase
    end

endmodule
