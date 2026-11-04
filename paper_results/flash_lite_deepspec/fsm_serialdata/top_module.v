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
    parameter ERROR = 4;

    // State register
    reg [2:0] state;

    // Internal registers
    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg in_prev;

    // Baud rate counter (assuming baud rate is a fraction of clk)
    // Adjust the divisor to match the baud rate.  This example assumes
    // that the baud rate is clk / 16.  This is a simplification and
    // a more robust design would use a more accurate baud rate generator.
    localparam BAUD_DIVISOR = 1; // Adjust this value to match the baud rate.
    reg [3:0] baud_counter;
    reg sample_in;

    // Combinational logic for start bit detection
    always @(posedge clk) begin
        in_prev <= in;
    end

    // State transition logic and data reception
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            bit_count <= 0;
            done <= 0;
            baud_counter <= 0;
            sample_in <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (in_prev == 1 && in == 0) begin // Start bit detected
                        state <= START_BIT;
                        baud_counter <= 0;
                        sample_in <= 0;
                    end
                end
                START_BIT: begin
                    if (baud_counter < BAUD_DIVISOR) begin
                        baud_counter <= baud_counter + 1;
                        sample_in <= 0;
                    end else begin
                        baud_counter <= 0;
                        state <= DATA_BITS;
                        sample_in <= 1;
                    end
                end
                DATA_BITS: begin
                    if (baud_counter < BAUD_DIVISOR) begin
                        baud_counter <= baud_counter + 1;
                        sample_in <= 0;
                    end else begin
                        baud_counter <= 0;
                        shift_reg <= {in, shift_reg[7:1]}; // LSB first
                        bit_count <= bit_count + 1;
                        sample_in <= 1;
                        if (bit_count == 7) begin
                            state <= STOP_BIT;
                        end
                    end
                end
                STOP_BIT: begin
                    if (baud_counter < BAUD_DIVISOR) begin
                        baud_counter <= baud_counter + 1;
                        sample_in <= 0;
                    end else begin
                        baud_counter <= 0;
                        sample_in <= 1;
                        if (in == 1) begin // Stop bit valid
                            out_byte <= shift_reg;
                            done <= 1;
                            state <= IDLE;
                        end else begin // Stop bit invalid
                            state <= ERROR;
                        end
                    end
                end
                ERROR: begin
                    done <= 0;
                    if (in == 1) begin // Wait for a logic 1 (idle)
                        state <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE;
                    done <= 0;
                end
            endcase
        end
    end
endmodule