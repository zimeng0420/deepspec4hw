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

    // Baud rate counter - assumes baud rate is a fraction of clk
    localparam BAUD_RATE_DIVISOR = 10; // Example:  clk_freq / (baud_rate * 2)  - adjust to your baud rate

    reg [3:0] baud_rate_counter;
    wire sample_bit;
    assign sample_bit = (baud_rate_counter == BAUD_RATE_DIVISOR - 1); // Sample at the middle of bit

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            bit_count <= 0;
            done <= 0;
            in_prev <= 1; // Assume idle is high
            baud_rate_counter <= 0;
        end else begin
            in_prev <= in;
            if (baud_rate_counter < BAUD_RATE_DIVISOR - 1) begin
                baud_rate_counter <= baud_rate_counter + 1;
            end else begin
                baud_rate_counter <= 0;
            end


            case (state)
                IDLE: begin
                    done <= 0;
                    if (in_prev == 1 && in == 0) begin // Start bit detected
                        state <= START_BIT;
                    end
                end
                START_BIT: begin
                    done <= 0;
                    if(sample_bit) begin
                       state <= DATA_BITS;
                       bit_count <= 0;
                       shift_reg <= 0;
                    end
                end
                DATA_BITS: begin
                    done <= 0;
                     if (sample_bit) begin
                        shift_reg <= {in, shift_reg[7:1]}; // LSB first
                        bit_count <= bit_count + 1;
                        if (bit_count == 7) begin
                            state <= STOP_BIT;
                        end
                    end
                end
                STOP_BIT: begin
                    done <= 0;
                    if(sample_bit) begin
                        if (in == 1) begin
                            out_byte <= shift_reg;
                            done <= 1;
                            state <= IDLE;
                        end else begin
                            state <= ERROR;
                        end
                    end

                end

                ERROR: begin
                    done <= 0;
                    if (in == 1 && sample_bit) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule