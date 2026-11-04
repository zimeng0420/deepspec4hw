module top_module (
	input clk,
	input in,
	input reset,
	output [7:0] out_byte,
	output done
);

    parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;

    reg [1:0] state;
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
            done_reg <= 1'b0; // Default value: done is de-asserted unless stop bit is found
            case (state)
                IDLE: begin
                    if (!in) begin // start bit detected
                        state <= START;
                    end
                end
                START: begin
                    state <= DATA;
                    bit_count <= 3'b0;
                end
                DATA: begin
                    data_reg[bit_count] <= in; // LSB first
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 3'b111) begin // All 8 data bits received
                        state <= STOP;
                    end
                end
                STOP: begin
                    if (in) begin // Stop bit correct
                        done_reg <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= IDLE; // Wait until next start bit, drop this byte
                    end
                end
            endcase
        end
    end

    assign out_byte = data_reg;
    assign done = done_reg;

endmodule