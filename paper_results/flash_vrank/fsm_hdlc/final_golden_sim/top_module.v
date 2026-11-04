module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err);

    // State definition
    parameter S_IDLE = 0;
    parameter S_1    = 1;
    parameter S_11   = 2;
    parameter S_111  = 3;
    parameter S_1111 = 4;
    parameter S_11111= 5;
    parameter S_111110= 6;
    parameter S_111111= 7;
    parameter S_ERROR = 8;

    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= 0;
            flag <= 0;
            err <= 0;

            case (state)
                S_IDLE: begin
                    if (in) begin
                        state <= S_1;
                    end else begin
                        state <= S_IDLE;
                    end
                end
                S_1: begin
                    if (in) begin
                        state <= S_11;
                    end else begin
                        state <= S_IDLE;
                    end
                end
                S_11: begin
                    if (in) begin
                        state <= S_111;
                    end else begin
                        state <= S_IDLE;
                    end
                end
                S_111: begin
                    if (in) begin
                        state <= S_1111;
                    end else begin
                        state <= S_IDLE;
                    end
                end
                S_1111: begin
                    if (in) begin
                        state <= S_11111;
                    end else begin
                        state <= S_IDLE;
                    end
                end
                S_11111: begin
                    if (in) begin
                        state <= S_111111;
                    end else begin
                        state <= S_111110;
                    end
                end
                S_111110: begin
                    disc <= 1;
                    if (in) begin
                        state <= S_1;
                    end else begin
                        state <= S_IDLE;
                    end
                end
                S_111111: begin
                    if (in) begin
                        state <= S_ERROR;
                    end else begin
                        flag <= 1;
                        state <= S_IDLE;
                    end
                end
                S_ERROR: begin
                    err <= 1;
                    if(in) begin
                        state <= S_ERROR;
                    end else begin
                        state <= S_IDLE;
                    end

                end
                default: state <= S_IDLE;
            endcase
        end
    end

endmodule