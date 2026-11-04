module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State Definitions
    parameter IDLE = 2'b00;
    parameter START_BIT = 2'b01;
    parameter DATA_BITS = 2'b10;
    parameter STOP_BIT = 2'b11;

    // Internal Signals
    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg in_prev;  // Store the previous value of 'in'
    reg baud_tick; // Baud rate clock tick - assuming baud rate is 1/16th the clk

    // Baud Rate Counter (Simplified - Assuming baud rate is clk/16)
    reg [3:0] baud_count;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            baud_count <= 4'b0;
            baud_tick <= 1'b0;
        end else begin
            if (baud_count == 4'd15) begin
                baud_count <= 4'b0;
                baud_tick <= 1'b1;
            end else begin
                baud_count <= baud_count + 1'b1;
                baud_tick <= 1'b0;
            end
        end
    end


    // State Machine Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            shift_reg <= 8'b0;
            bit_count <= 3'b0;
            in_prev <= 1'b1; // Assume idle is high
        end else begin
            in_prev <= in; // Store previous input for start bit detection

            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in_prev == 1'b1 && in == 1'b0 && baud_tick) begin // Start bit detected
                        state <= START_BIT;
                        bit_count <= 3'b0;
                    end else begin
                        state <= IDLE;
                    end
                end
                START_BIT: begin
                  if (baud_tick) begin
                    state <= DATA_BITS;
                  end else begin
                    state <= START_BIT;
                  end
                end
                DATA_BITS: begin
                    if (baud_tick) begin
                      shift_reg <= {in, shift_reg[7:1]}; // Shift data in (LSB first)
                      bit_count <= bit_count + 1'b1;
                    end

                    if (bit_count == 3'd7) begin // 8 data bits received
                        state <= STOP_BIT;
                    end else begin
                        state <= DATA_BITS;
                    end
                end
                STOP_BIT: begin
                  if (baud_tick) begin
                    if (in == 1'b1) begin // Stop bit valid
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin // Stop bit invalid - wait for a high
                        done <= 1'b0;
                        state <= IDLE; // Go back to idle to search for next start bit
                    end
                  end else begin
                    state <= STOP_BIT;
                  end
                end
                default: begin
                    state <= IDLE;
                    done <= 1'b0;
                    shift_reg <= 8'b0;
                    bit_count <= 3'b0;
                end
            endcase
        end
    end
endmodule