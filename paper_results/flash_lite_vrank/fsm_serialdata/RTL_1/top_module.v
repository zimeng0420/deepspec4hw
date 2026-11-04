module top_module (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    parameter IDLE = 0;
    parameter START = 1;
    parameter DATA = 2;
    parameter STOP = 3;
    parameter ERROR = 4;

    reg [2:0] state;
    reg [2:0] next_state;
    reg [7:0] data_reg;
    reg [2:0] bit_count;
    reg done_reg;
    reg [7:0] out_byte_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 0;
            bit_count <= 0;
            out_byte_reg <= 0;
        end else begin
            state <= next_state;
            done_reg <= 0; // Default value
            case (state)
                IDLE: begin
                    if (!in) begin
                        next_state <= START;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                START: begin
                    next_state <= DATA;
                    bit_count <= 0;
                end
                DATA: begin
                    data_reg[bit_count] <= in;
                    bit_count <= bit_count + 1;
                    if (bit_count == 7) begin
                        next_state <= STOP;
                    end else begin
                        next_state <= DATA;
                    end
                end
                STOP: begin
                    if (in) begin
                        next_state <= IDLE;
                        done_reg <= 1;
                        out_byte_reg <= data_reg;
                    end else begin
                        next_state <= ERROR;
                    end
                end
                ERROR: begin
                    if (in) begin
                        next_state <= IDLE;
                    end else begin
                        next_state <= ERROR;
                    end
                end
            endcase
        end
    end

    assign done = done_reg;
    assign out_byte = out_byte_reg;

endmodule