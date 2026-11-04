module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output done
);

    reg [1:0] state;
    reg done_r;

    parameter IDLE = 0;
    parameter BYTE1 = 1;
    parameter BYTE2 = 2;
    parameter BYTE3 = 3;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_r <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done_r <= 0;
                    if (in[3]) begin
                        state <= BYTE1;
                    end else begin
                        state <= IDLE;
                    end
                end
                BYTE1: begin
                    state <= BYTE2;
                end
                BYTE2: begin
                    state <= BYTE3;
                end
                BYTE3: begin
                    state <= IDLE;
                    done_r <= 1;
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