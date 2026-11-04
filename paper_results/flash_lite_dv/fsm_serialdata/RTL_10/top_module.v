module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Define states
    parameter IDLE = 2'b00;
    parameter START_BIT = 2'b01;
    parameter DATA_BITS = 2'b10;
    parameter STOP_BIT = 2'b11;

    // Internal signals
    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg in_prev;

    // Clock divider for baud rate (assuming baud rate is same as clock rate - no division)
    // Can be modified to implement baud rate division
    
    // Start bit detection - simple edge detection
    wire start_bit_detected = (in_prev == 1'b1) && (in == 1'b0);

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            bit_count <= 3'b000;
            shift_reg <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start_bit_detected) begin
                        state <= START_BIT;
                    end
                end
                START_BIT: begin
                    state <= DATA_BITS;
                end
                DATA_BITS: begin
                    shift_reg <= {in, shift_reg[7:1]}; // Shift in the data bits, LSB first
                    bit_count <= bit_count + 1;
                    if (bit_count == 3'b111) begin // 8 data bits received
                        state <= STOP_BIT;
                        bit_count <= 3'b000; // Reset counter for next byte
                    end
                end
                STOP_BIT: begin
                    if (in == 1'b1) begin // Check stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= IDLE; // Wait for next start bit - Framing error, reset the FSM to IDLE.
                        done <= 1'b0;
                    end
                end
                default: begin
                    state <= IDLE;
                    done <= 1'b0;
                    bit_count <= 3'b000;
                    shift_reg <= 8'b0;
                end
            endcase
        end
        in_prev <= in;
    end
endmodule