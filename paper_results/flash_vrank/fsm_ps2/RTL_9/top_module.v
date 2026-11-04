module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output done
);

    reg done;
    reg [1:0] state;

    localparam IDLE = 0;
    localparam BYTE1 = 1;
    localparam BYTE2 = 2;
    localparam BYTE3 = 3;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (in[3]) begin
                        state <= BYTE1;
                    end else begin
                        state <= IDLE;
                    end
                end
                BYTE1: begin
                    state <= BYTE2;
                    done <= 0;
                end
                BYTE2: begin
                    state <= BYTE3;
                    done <= 0;
                end
                BYTE3: begin
                    state <= IDLE;
                    done <= 1;
                end
                default: begin
                    state <= IDLE;
                    done <= 0;
                end
            endcase
        end
    end

endmodule