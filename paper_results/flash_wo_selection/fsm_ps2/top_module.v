module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output done
);

    reg [1:0] state;
    reg done_r;

    // Define state encoding
    localparam S_IDLE = 2'b00;
    localparam S_BYTE1 = 2'b01;
    localparam S_BYTE2 = 2'b10;
    localparam S_BYTE3 = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            done_r <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (in[3]) begin
                        state <= S_BYTE1;
                        done_r <= 0;
                    end else begin
                        state <= S_IDLE;
                        done_r <= 0;
                    end
                end
                S_BYTE1: begin
                    state <= S_BYTE2;
                    done_r <= 0;
                end
                S_BYTE2: begin
                    state <= S_BYTE3;
                    done_r <= 0;
                end
                S_BYTE3: begin
                    state <= S_IDLE;
                    done_r <= 1;
                end
                default: begin
                    state <= S_IDLE;
                    done_r <= 0;
                end
            endcase
        end
    end

    assign done = done_r;

endmodule