module top_module (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    parameter IDLE = 0;
    parameter START_BIT = 1;
    parameter DATA_BITS = 2;
    parameter STOP_BIT = 3;
    parameter WAIT_STOP = 4;

    reg [2:0] state;
    reg [7:0] data_reg;
    reg [2:0] bit_count;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_reg <= 8'b0;
            bit_count <= 3'b0;
            done_reg <= 1'b0;
        end else begin
            done_reg <= 1'b0;
            case (state)
                IDLE: begin
                    if (!in) begin // Start bit detected (0)
                        state <= START_BIT;
                    end
                end
                START_BIT: begin
                    if (in) begin // Expecting first data bit
                        state <= DATA_BITS;
                        bit_count <= 3'b0;
                    end else begin
                        state <= IDLE; // Resync if start bit is low again immediately
                    end
                end
                DATA_BITS: begin
                    data_reg[bit_count] <= in;
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 3'd7) begin // all 8 data bits received
                        state <= STOP_BIT;
                    end
                end
                STOP_BIT: begin
                    if (in) begin // Stop bit detected (1)
                        done_reg <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end
                WAIT_STOP: begin
                    if (in) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    assign out_byte = data_reg;
    assign done = done_reg;

endmodule