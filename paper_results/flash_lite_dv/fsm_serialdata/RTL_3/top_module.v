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
    parameter DATA = 2;
    parameter STOP_BIT = 3;
    parameter ERROR = 4; // Added error state

    // State register
    reg [2:0] state;

    // Internal registers
    reg [7:0] data_reg;
    reg [2:0] bit_count;
    reg in_prev;
    reg baud_tick;
    localparam BAUD_RATE_DIVISOR = 16;  // Assuming baud rate clock is 16x faster. Adjust this based on actual baud rate.
    reg [3:0] baud_counter;
    // Baud rate clock generation (simplified - assumes faster clock)
    always @(posedge clk) begin
        baud_counter <= baud_counter + 1;
        baud_tick <= (baud_counter == BAUD_RATE_DIVISOR - 1) ? 1 : 0;
        if (baud_counter == BAUD_RATE_DIVISOR - 1)
            baud_counter <= 0;
    end

    // Sequential logic
    always @(posedge clk) begin
        // Reset
        if (reset) begin
            state <= IDLE;
            data_reg <= 0;
            bit_count <= 0;
            done <= 0;
            in_prev <= 1; //Assume idle state is high.
        end else begin
            in_prev <= in;  // Sample input for start bit detection

            case (state)
                IDLE: begin
                    done <= 0;
                    if (in_prev && !in) begin // Start bit detected (falling edge)
                        state <= START_BIT;
                        bit_count <= 0;
                    end
                end
                START_BIT: begin
                    if(baud_tick) begin
                      state <= DATA;
                    end
                end
                DATA: begin
                    if (baud_tick) begin
                        data_reg <= {in, data_reg[7:1]}; // Shift in data (LSB first)
                        bit_count <= bit_count + 1;
                        if (bit_count == 7) begin
                            state <= STOP_BIT;
                            bit_count <= 0;
                        end
                    end
                end
                STOP_BIT: begin
                    if (baud_tick) begin
                        if (in) begin // Stop bit valid
                            out_byte <= data_reg;
                            done <= 1;
                            state <= IDLE;
                        end else begin // Stop bit error
                            state <= ERROR;
                            done <= 0;
                        end
                    end
                end
                ERROR: begin  // Handle stop bit error
                    done <= 0;
                    if (in) begin // Wait for high, then go back to IDLE
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule