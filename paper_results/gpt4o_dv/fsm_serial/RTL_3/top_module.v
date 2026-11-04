module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // States of the FSM
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        START_BIT = 3'b001,
        RECEIVE_DATA = 3'b010,
        STOP_BIT = 3'b011,
        ERROR = 3'b100
    } state_t;
    
    reg [2:0] state, next_state;
    reg [3:0] bit_counter;  // Count the received data bits
    reg [7:0] data_reg;     // Shift register to hold the received byte

    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(posedge clk) begin
        if (reset) begin
            bit_counter <= 0;
            data_reg <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                end
                START_BIT: begin
                    done <= 0;
                end
                RECEIVE_DATA: begin
                    data_reg <= {in, data_reg[7:1]};  // Store the bits in a shift register, LSB first
                    bit_counter <= bit_counter + 1;
                end
                STOP_BIT: begin
                    done <= 1;   // Indicate a complete and valid sequence
                end
                ERROR: begin
                    done <= 0;
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 0)    // Detected start bit (0)
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end
            START_BIT: begin
                next_state = RECEIVE_DATA;
            end
            RECEIVE_DATA: begin
                if (bit_counter == 7)
                    next_state = STOP_BIT;
                else
                    next_state = RECEIVE_DATA;
            end
            STOP_BIT: begin
                if (in == 1)  // Verify stop bit (1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            ERROR: begin
                if (in == 1)  // Wait for correct stop bit (1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule