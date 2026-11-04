module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // Define states
    typedef enum reg [2:0] {
        IDLE       = 3'b000,
        START_BIT  = 3'b001,
        DATA_BITS  = 3'b010,
        STOP_BIT   = 3'b011,
        ERROR      = 3'b100
    } state_t;

    // State register and next state logic
    reg [2:0] state, next_state;
    reg [7:0] data_reg; // Shift register to store the 8 data bits
    reg [3:0] bit_counter; // Counter to keep track of the number of data bits received

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_reg <= 8'b0;
            bit_counter <= 4'b0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 0) // Detecting start bit
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end
            START_BIT: begin
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                if (bit_counter == 8) // All data bits received
                    next_state = STOP_BIT;
                else
                    next_state = DATA_BITS;
            end
            STOP_BIT: begin
                if (in == 1) // Valid stop bit
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            ERROR: begin
                if (in == 1) // Waiting for a valid stop bit
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic and data reception
    always @(posedge clk) begin
        if (reset) begin
            done <= 0;
            bit_counter <= 0;
        end else begin
            case (state)
                START_BIT: begin
                    bit_counter <= 0;
                    done <= 0;
                end
                DATA_BITS: begin
                    data_reg <= {in, data_reg[7:1]}; // Shift in data bits
                    bit_counter <= bit_counter + 1;
                    done <= 0;
                end
                STOP_BIT: begin
                    done <= 1; // Signals successful byte reception
                end
                default: done <= 0;
            endcase
        end
    end

endmodule