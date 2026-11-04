module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // States
    parameter IDLE = 0;
    parameter START_BIT = 1;
    parameter DATA_BITS = 2;
    parameter STOP_BIT = 3;
    parameter ERROR = 4;


    // Internal Signals
    reg [2:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg in_prev;
    reg start_bit_detected;

    // Baud Rate Counter (Assuming baud rate is derived from clk, adjust divisor as needed)
    localparam BAUD_DIVISOR = 1; // Adjust this for the baud rate.  Assumes clk is faster than the baud rate.  For example, clk_freq / baud_rate = 16, then BAUD_DIVISOR = 16.
    reg [3:0] baud_counter;
    reg sample_in;

    // FSM Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            bit_count <= 3'b0;
            done <= 1'b0;
            in_prev <= 1'b1;
            baud_counter <= 4'b0;
            sample_in <= 1'b0;
            out_byte <= 8'b0;

        end else begin
            in_prev <= in;
            start_bit_detected <= (in_prev == 1'b1) && (in == 1'b0) ; // Detect falling edge for start bit

            // Baud Rate Sampling
            if (baud_counter == BAUD_DIVISOR -1) begin
                sample_in <= 1'b1;
                baud_counter <= 4'b0;
            end else begin
                sample_in <= 1'b0;
                baud_counter <= baud_counter + 1'b1;
            end


            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start_bit_detected) begin
                         state <= START_BIT;
                    end else begin
                        state <= IDLE;
                    end
                end
                START_BIT: begin
                  if (sample_in) begin
                     if (in == 1'b0)  // Check for start bit again after sampling.
                         state <= DATA_BITS;
                     else
                        state <= ERROR;
                  end else
                    state <= START_BIT;
                end
                DATA_BITS: begin
                  if (sample_in) begin
                        shift_reg <= {in, shift_reg[7:1]};
                        bit_count <= bit_count + 1'b1;
                        if (bit_count == 3'b111) begin // 8 bits received
                            state <= STOP_BIT;
                            bit_count <= 3'b0;
                        end else begin
                            state <= DATA_BITS;
                        end
                  end else
                    state <= DATA_BITS;

                end
                STOP_BIT: begin
                    if (sample_in) begin
                      if (in == 1'b1) begin
                          out_byte <= shift_reg;
                          done <= 1'b1;
                          state <= IDLE;
                      end else begin
                          state <= ERROR;  // Incorrect stop bit
                      end
                  end else
                    state <= STOP_BIT;
                end

                ERROR: begin  // Wait for a valid stop bit and then re-sync.
                    done <= 1'b0;
                    if (in == 1'b1) begin
                        state <= IDLE;
                    end else begin
                        state <= ERROR;
                    end
                end
                default: begin
                    state <= IDLE;
                    done <= 1'b0;
                    out_byte <= 8'b0;
                end
            endcase
        end
    end
endmodule