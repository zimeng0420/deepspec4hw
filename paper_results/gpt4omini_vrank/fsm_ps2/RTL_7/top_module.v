module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output done
);
    reg [1:0] state;
    reg done_reg;

    localparam IDLE = 2'b00, BYTE1 = 2'b01, BYTE2 = 2'b10, BYTE3 = 2'b11;

    assign done = done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1) begin
                        state <= BYTE1;
                        done_reg <= 0;
                    end
                end
                BYTE1: begin
                    state <= BYTE2;
                end
                BYTE2: begin
                    state <= BYTE3;
                end
                BYTE3: begin
                    done_reg <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule