module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State Definition
    parameter IDLE      = 3'b000;
    parameter START_BIT = 3'b001;
    parameter DATA_BITS = 3'b010;
    parameter STOP_BIT  = 3'b011;
    parameter ERROR     = 3'b100;

    // State Register
    reg [2:0] current_state, next_state;

    // Data Bit Counter
    reg [2:0] bit_counter;

    // Internal Signals
    reg data_bit;

    // State Transition Logic
    always @(*) begin
        next_state = current_state;
        done = 1'b0; // Default: not done

        case (current_state)
            IDLE: begin
                if (in == 1'b0) begin // Start bit detected
                    next_state = START_BIT;
                end
            end
            START_BIT: begin
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                if (bit_counter == 3'd7) begin // 8 data bits received
                    next_state = STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in == 1'b1) begin // Stop bit valid
                    next_state = IDLE;
                    done = 1'b1;
                end else begin // Stop bit invalid
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in == 1'b1) begin // Wait for stop bit
                    next_state = IDLE;
                end
            end
            default:
                next_state = IDLE;
        endcase
    end

    // State Register Update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            bit_counter <= 3'b000;
        end else begin
            current_state <= next_state;
            if (current_state == DATA_BITS) begin
                bit_counter <= bit_counter + 1'b1;
            end else if (next_state == START_BIT) begin
                bit_counter <= 3'b000;
            end
        end
    end

endmodule