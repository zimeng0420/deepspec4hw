module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        START = 3'b001,
        DATA = 3'b010,
        STOP = 3'b011,
        ERROR = 3'b100
    } state_t;

    reg [2:0] state, next_state;
    reg [7:0] shift_register;
    reg [2:0] bit_counter;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 0;
            shift_register <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;

            case (state)
                DATA: begin
                    shift_register <= {in, shift_register[7:1]}; // Shift in LSB serially
                    bit_counter <= bit_counter + 1;
                end
                STOP: begin
                    out_byte <= shift_register; // Latch received byte
                end
                default: begin
                    bit_counter <= 0;
                    shift_register <= 0;
                end
            endcase
        end
    end

    // Next state logic and output logic
    always @(*) begin
        // Default assignments
        next_state = state;
        done = 0;

        case (state)
            IDLE: begin
                if (!in) // Start bit detection (logic 0)
                    next_state = START;
            end
            START: begin
                // Confirm start bit and move to data reception
                next_state = DATA;
            end
            DATA: begin
                if (bit_counter == 3'd7) // After 8 data bits (0-7 index)
                    next_state = STOP;
            end
            STOP: begin
                if (in) begin // Stop bit detected (logic 1)
                    next_state = IDLE;
                    done = 1;
                end else begin // Error handling
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in) // Wait for idle (logic 1) before restarting
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule