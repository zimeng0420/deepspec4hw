module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // States
    parameter IDLE = 2'b00;
    parameter START_BIT = 2'b01;
    parameter DATA_BITS = 2'b10;
    parameter STOP_BIT = 2'b11;

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg in_prev;
    reg baud_tick;

    // Baud rate counter - Assuming baud rate is 1/16 of the clock rate for simplicity
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            baud_tick <= 1'b0;
        end else begin
            baud_tick <= ~baud_tick;
        end
    end


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            bit_count <= 3'b000;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (!in && baud_tick) begin // Start bit detected (falling edge)
                        state <= START_BIT;
                    end else begin
                        state <= IDLE;
                    end
                end
                START_BIT: begin
                    state <= DATA_BITS;
                end
                DATA_BITS: begin
                    if (baud_tick) begin // Sample data bits
                        shift_reg <= {in, shift_reg[7:1]}; // LSB first
                        bit_count <= bit_count + 1;
                    end
                    if (bit_count == 3'b111) begin // All 8 data bits received
                        state <= STOP_BIT;
                    end else begin
                        state <= DATA_BITS;
                    end
                end
                STOP_BIT: begin
                    if (baud_tick) begin
                        if (in) { // Stop bit valid
                            out_byte <= shift_reg;
                            done <= 1'b1;
                            state <= IDLE;
                        } else {
                            // Framing error: wait for a stop bit
                            state <= STOP_BIT;
                        }
                    end
                end
                default: begin
                    state <= IDLE;
                    done <= 1'b0;
                    bit_count <= 3'b000;
                    shift_reg <= 8'b0;
                    out_byte <= 8'b0;
                end
            endcase
        end
    end


    always @(posedge clk) begin
        in_prev <= in;
    end

endmodule