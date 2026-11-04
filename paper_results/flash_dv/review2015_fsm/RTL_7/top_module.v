module top_module(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // Define states
    typedef enum logic [2:0] {
        IDLE,
        SHIFT,
        COUNTING,
        DONE
    } state_t;

    reg state;
    reg next_state;
    reg [1:0] shift_count;

    // Pattern detection
    reg data_d1;
    reg data_d2;
    reg data_d3;
    wire pattern_detected;

    assign pattern_detected = data && data_d1 && ~data_d2 && data_d3;

    // Next state logic
    always_comb begin
        case (state)
            IDLE: begin
                if (pattern_detected) begin
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end
            SHIFT: begin
                if (shift_count == 2'b11) begin
                    next_state = COUNTING;
                end else begin
                    next_state = SHIFT;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    next_state = DONE;
                end else begin
                    next_state = COUNTING;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = DONE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // State and shift_count update
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'b00;
            data_d1 <= 1'b0;
            data_d2 <= 1'b0;
            data_d3 <= 1'b0;
        end else begin
            state <= next_state;
            data_d1 <= data;
            data_d2 <= data_d1;
            data_d3 <= data_d2;

            if (state == SHIFT) begin
                if (shift_count < 2'b11) begin
                    shift_count <= shift_count + 1'b1;
                end
            end else begin
                shift_count <= 2'b00;
            end
        end
    end

    // Output logic
    always_ff @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                SHIFT: begin
                    if (shift_count < 2'b10) begin
                        shift_ena <= 1'b1;
                    end else begin
                        shift_ena <= 1'b0;
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                COUNTING: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                end
                DONE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
                default: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule