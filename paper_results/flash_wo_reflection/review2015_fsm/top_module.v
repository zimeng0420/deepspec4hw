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
    typedef enum logic [2:0] {
        IDLE,
        SHIFT,
        COUNTING,
        DONE
    } state_t;

    reg state_t current_state, next_state;
    reg [1:0] shift_counter;
    reg [3:0] data_history;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_counter <= 2'b00;
        end else begin
            current_state <= next_state;
            if (current_state == SHIFT) begin
                if (shift_counter < 2'b11) begin
                    shift_counter <= shift_counter + 1'b1;
                end
            end else begin
                shift_counter <= 2'b00;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state; // Default: stay in the same state
        case (current_state)
            IDLE: begin
                if (data_history == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                if (shift_counter == 2'b11) begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (current_state)
            IDLE: begin
                shift_ena = 0;
                counting = 0;
                done = 0;
            end
            SHIFT: begin
                shift_ena = 1;
                counting = 0;
                done = 0;
            end
            COUNTING: begin
                shift_ena = 0;
                counting = 1;
                done = 0;
            end
            DONE: begin
                shift_ena = 0;
                counting = 0;
                done = 1;
            end
            default: begin
                shift_ena = 0;
                counting = 0;
                done = 0;
            end
        endcase
    end

    // Data history shift register
    always @(posedge clk) begin
        if (reset) begin
            data_history <= 4'b0000;
        end else begin
            data_history <= {data_history[2:0], data};
        end
    end

endmodule