module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Define states
    parameter IDLE = 0;
    parameter START_BIT = 1;
    parameter DATA_BITS = 2;
    parameter STOP_BIT = 3;
    parameter WAIT_FOR_STOP = 4;

    // Internal signals
    reg [2:0] state;
    reg [7:0] data_reg;
    reg [2:0] bit_count;
    reg in_prev;

    // Clock divider (assuming baud rate is a fraction of clk) - Adjust divisor as needed
    // This implementation is a basic example, and might need modification based on the baud rate
    // For example, if the baud rate is clk/16, then clk_count should count to 8 (2 clock cycles per bit)
    // If the clock frequency and baud rate are not known, the design would need a more accurate
    // baud rate clock generator, for example, a counter and comparison, like the code below.
    reg [3:0] clk_count; // Assuming 16 clk cycles per bit
    wire sample_clk_tick; // Indicates the sampling clock

    always @(posedge clk) begin
        if (reset) begin
            clk_count <= 0;
        end else begin
            if (clk_count < 15) begin
                clk_count <= clk_count + 1;
            end else begin
                clk_count <= 0;
            end
        end
    end

    assign sample_clk_tick = (clk_count == 7); // Sample in the middle of the bit time

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            out_byte <= 0;
            bit_count <= 0;
            in_prev <= 1; // Assume idle line is high
        end else begin
            in_prev <= in;  // Sample the input to detect changes on next clock cycle
            case (state)
                IDLE: begin
                    done <= 0;
                    if (~in_prev & sample_clk_tick) begin // Start bit detected
                        state <= START_BIT;
                    end
                end
                START_BIT: begin
                    if (sample_clk_tick) begin // Wait for the start bit to stabilize
                        state <= DATA_BITS;
                        bit_count <= 0;
                    end
                end
                DATA_BITS: begin
                    if (sample_clk_tick) begin
                        data_reg[bit_count] <= in;
                        bit_count <= bit_count + 1;
                        if (bit_count == 7) begin
                            state <= STOP_BIT;
                        end
                    end
                end
                STOP_BIT: begin
                    if (sample_clk_tick) begin
                        if (in == 1) begin // Stop bit detected
                            out_byte <= data_reg;
                            done <= 1;
                            state <= IDLE;
                        end else begin
                            state <= WAIT_FOR_STOP; // Stop bit error
                        end
                    end
                end
                WAIT_FOR_STOP: begin
                    done <= 0;
                    if (in == 1) begin // Look for next stop bit
                        state <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE; // Handle unexpected states
                end
            endcase
        end
    end
endmodule