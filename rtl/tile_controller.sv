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
    output logic [3:0] cycle_count
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
            tile_row    <= 0;
            tile_col    <= 0;
            k_tile      <= 0;
            cycle_count <= 0;
        end else begin
            case (state)

                IDLE: begin
                    tile_row    <= 0;
                    tile_col    <= 0;
                    k_tile      <= 0;
                    cycle_count <= 0;

                    if (start)
                        state <= CLEAR;
                end

                CLEAR: begin
                    cycle_count <= 0;
                    state <= RUN;
                end

                RUN: begin
                    if (cycle_count == 9) begin
                        cycle_count <= 0;

                        if (k_tile == 3)
                            state <= SAVE;
                        else
                            k_tile <= k_tile + 1;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                end

                SAVE: begin
                    k_tile <= 0;

                    if (tile_row == 3 && tile_col == 3) begin
                        state <= DONE;
                    end else begin
                        if (tile_col == 3) begin
                            tile_col <= 0;
                            tile_row <= tile_row + 1;
                        end else begin
                            tile_col <= tile_col + 1;
                        end

                        state <= CLEAR;
                    end
                end

                DONE: begin
                    state <= IDLE;
                end

                default: state <= IDLE;

            endcase
        end
    end

    always_comb begin
        clear_array  = 0;
        enable_array = 0;
        save_result  = 0;
        busy         = 0;
        done         = 0;

        case (state)
            CLEAR: begin
                busy = 1;
                clear_array = 1;
            end

            RUN: begin
                busy = 1;
                enable_array = 1;
            end

            SAVE: begin
                busy = 1;
                save_result = 1;
            end

            DONE: begin
                done = 1;
            end

            default: begin
            end
        endcase
    end

endmodule
