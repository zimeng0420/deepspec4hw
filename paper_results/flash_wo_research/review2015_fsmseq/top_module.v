module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state;

parameter S_IDLE = 3'b000;
parameter S_1    = 3'b001;
parameter S_11   = 3'b010;
parameter S_110  = 3'b011;
parameter S_1101 = 3'b100;
parameter S_FOUND = 3'b101;

always @(posedge clk) begin
    if (reset) begin
        state <= S_IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            S_IDLE: begin
                if (data == 1'b1) begin
                    state <= S_1;
                end else begin
                    state <= S_IDLE;
                end
            end
            S_1: begin
                if (data == 1'b1) begin
                    state <= S_11;
                end else begin
                    state <= S_IDLE;
                end
            end
            S_11: begin
                if (data == 1'b0) begin
                    state <= S_110;
                end else begin
                    state <= S_11;
                end
            end
            S_110: begin
                if (data == 1'b1) begin
                    state <= S_1101;
                end else begin
                    if (data == 1'b0)
                        state <= S_110;
                    else
                        state <= S_1;
                end
            end
            S_1101: begin
                state <= S_FOUND;
                start_shifting <= 1;
            end
            S_FOUND: begin
                start_shifting <= 1;
                state <= S_FOUND;
            end
            default: begin
                state <= S_IDLE;
                start_shifting <= 0;
            end
        endcase
    end
end

endmodule