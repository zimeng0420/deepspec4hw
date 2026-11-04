module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State Definition
    parameter IDLE = 3'b000;
    parameter START_BIT = 3'b001;
    parameter DATA_BITS = 3'b010;
    parameter STOP_BIT = 3'b011;
    parameter ERROR = 3'b100;

    // Internal Signals
    reg [2:0] current_state, next_state;
    reg [2:0] data_bit_counter;
    reg data_bit_valid;

    // State Register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            data_bit_counter <= 0;
            done <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        next_state = current_state;
        done = 0;
        data_bit_valid = 0;

        case (current_state)
            IDLE: begin
                if (!in) begin
                    next_state = START_BIT;
                end
            end
            START_BIT: begin
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                if (data_bit_counter == 7) begin
                    next_state = STOP_BIT;
                end else begin
                    next_state = DATA_BITS;
                end
            end
            STOP_BIT: begin
                if (in) begin
                    next_state = IDLE;
                    done = 1;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Data Bit Counter Logic
    always @(posedge clk) begin
        if (reset) begin
            data_bit_counter <= 0;
        end else begin
            if (current_state == DATA_BITS) begin
                if (data_bit_counter < 7) begin
                    data_bit_counter <= data_bit_counter + 1;
                end
            end
        end
    end

endmodule