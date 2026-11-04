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
    parameter ERROR = 4;

    reg [2:0] state;
    reg [7:0] data_reg;
    reg in_prev;
    reg [2:0] bit_count;
    reg done_internal;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_reg <= 8'b0;
            bit_count <= 3'b0;
            done_internal <= 1'b0;
        end else begin
            in_prev <= in;
            done_internal <= 1'b0;
            case (state)
                IDLE: begin
                    if (!in && in_prev) begin // Start bit detected (falling edge)
                        state <= START_BIT;
                    end else begin
                        state <= IDLE;
                    end
                end
                START_BIT: begin
                    // Wait for the start bit to settle (optional, depends on baud rate)
                    state <= DATA_BITS;
                    bit_count <= 3'b0;
                end
                DATA_BITS: begin
                    data_reg[bit_count] <= in;
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 3'd7) begin
                        state <= STOP_BIT;
                    end else begin
                        state <= DATA_BITS;
                    end
                end
                STOP_BIT: begin
                    if (in) begin // Stop bit valid
                        done_internal <= 1'b1;
                        state <= IDLE;
                    end else begin // Stop bit invalid
                        state <= ERROR;
                    end
                end
                ERROR: begin
                    if(in) begin // Wait for the next valid bit
                       state <= IDLE;
                    end else begin
                       state <= ERROR;
                    end
                end
                default: begin
                    state <= IDLE;
                    bit_count <= 3'b0;
                    data_reg <= 8'b0;
                    done_internal <= 1'b0;

                end
            endcase
        end
    end

    assign out_byte = data_reg;
    assign done = done_internal;

endmodule