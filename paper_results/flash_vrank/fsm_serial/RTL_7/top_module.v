module top_module (
    input clk,
    input in,
    input reset,
    output done
);

    reg [3:0] state;
    reg [7:0] data_reg;
    reg [3:0] bit_count;
    reg done_r;

    parameter IDLE = 4'b0000;
    parameter START = 4'b0001;
    parameter DATA = 4'b0010;
    parameter STOP = 4'b0011;
    parameter ERROR = 4'b0100;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
            done_r <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done_r <= 0;
                    if (in == 0) begin
                        state <= START;
                        bit_count <= 0;
                    end
                end
                START: begin
                    state <= DATA;
                    bit_count <= 0;
                end
                DATA: begin
                    data_reg[bit_count] <= in;
                    if (bit_count == 7) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                STOP: begin
                    if (in == 1) begin
                        state <= IDLE;
                        done_r <= 1;
                    end else begin
                        state <= ERROR;
                    end
                end
                ERROR: begin
                    if(in == 1) begin
                        state <= IDLE;
                        done_r <= 0;
                    end else begin
                        done_r <= 0;
                    end
                end
                default: begin
                    state <= IDLE;
                    done_r <= 0;
                end
            endcase
        end
    end

    assign done = done_r;

endmodule