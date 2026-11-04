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
    parameter DATA = 2'b10;
    parameter STOP_BIT = 2'b11;

    // Internal signals
    reg [1:0] state;
    reg [7:0] data_reg;
    reg in_prev;
    reg [3:0] bit_count;
    reg baud_tick;

    // Baud rate generation (Assuming baud rate is derived from the clock.  Needs adjustment for actual baud rate)
    // For demonstration, a simple clock divider is implemented. Adjust the divisor for the correct baud rate
    localparam CLOCK_DIVISOR = 4; // Example: Divide the clock by 4
    reg [2:0] clock_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clock_counter <= 0;
            baud_tick <= 0;
        end else begin
            clock_counter <= clock_counter + 1;
            if (clock_counter == CLOCK_DIVISOR - 1) begin
                baud_tick <= 1;
                clock_counter <= 0;
            end else begin
                baud_tick <= 0;
            end
        end
    end
    

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            bit_count <= 0;
            in_prev <= 1; // Assuming idle is high
        end else begin
            in_prev <= in;
            case (state)
                IDLE: begin
                    done <= 0;
                    if (in_prev == 1 && in == 0) begin // Start bit detected
                        state <= START_BIT;
                    end
                end
                START_BIT: begin
                    state <= DATA;
                    bit_count <= 0;
                end
                DATA: begin
                    if (baud_tick) begin
                        data_reg[bit_count] <= in;
                        bit_count <= bit_count + 1;
                    end
                    if (bit_count == 7 && baud_tick) begin
                        state <= STOP_BIT;
                    end
                end
                STOP_BIT: begin
                    if (baud_tick) begin
                        if (in == 1) begin // Valid stop bit
                            done <= 1;
                            state <= IDLE;
                        end else begin // Invalid stop bit - wait for a valid stop bit
                            state <= IDLE; // Go back to idle, will wait for a valid start and stop bit in new byte.
                        end
                    end
                end
            endcase
        end
    end

    // Output logic
    always @(posedge clk) begin
        if (done) begin
            out_byte <= data_reg;
        end
    end

endmodule