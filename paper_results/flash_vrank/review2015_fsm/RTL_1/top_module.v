module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    // Define states
    typedef enum logic [3:0] {
        IDLE,
        S1,
        S2,
        S3,
        SHIFT,
        COUNTING,
        DONE
    } state_t;

    reg state, next_state;
    reg [2:0] shift_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (state)
            IDLE: begin
                if (data) begin
                    next_state = S1;
                end else begin
                    next_state = IDLE;
                end
            end
            S1: begin
                if (data) begin
                    next_state = S2;
                end else begin
                    next_state = IDLE;
                end
            end
            S2: begin
                if (~data) begin
                    next_state = S3;
                end else begin
                    next_state = IDLE;
                end
            end
            S3: begin
                if (data) begin
                    next_state = SHIFT;
                    shift_ena = 1;
                end else begin
                    next_state = IDLE;
                end
            end
            SHIFT: begin
                shift_ena = 1;
                if (shift_count == 3) begin
                    next_state = COUNTING;
                end else begin
                    next_state = SHIFT;
                end
            end
            COUNTING: begin
                counting = 1;
                if (done_counting) begin
                    next_state = DONE;
                end else begin
                    next_state = COUNTING;
                end
            end
            DONE: begin
                done = 1;
                if (ack) begin
                    next_state = IDLE;
                end else {
					next_state = DONE;
				}
            end
            default: next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            shift_count <= 0;
        end else if (state == SHIFT && next_state == SHIFT) begin
            shift_count <= shift_count + 1;
        end else begin
            shift_count <= 0;
        end
    end

endmodule