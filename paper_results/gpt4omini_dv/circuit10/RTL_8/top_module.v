module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    case (state)
        1'b0: begin
            if (a == 0 && b == 0) begin
                state <= 1'b0;
                q <= 1'b0;
            end else if (a == 0 && b == 1) begin
                state <= 1'b1;
                q <= 1'b1;
            end else if (a == 1 && b == 0) begin
                state <= 1'b1;
                q <= 1'b1;
            end else if (a == 1 && b == 1) begin
                state <= 1'b0;
                q <= 1'b0;
            end
        end
        1'b1: begin
            if (a == 0 && b == 0) begin
                state <= 1'b0;
                q <= 1'b0;
            end else if (a == 0 && b == 1) begin
                state <= 1'b1;
                q <= 1'b1;
            end else if (a == 1 && b == 0) begin
                state <= 1'b0;
                q <= 1'b0;
            end else if (a == 1 && b == 1) begin
                state <= 1'b1;
                q <= 1'b1;
            end
        end
    endcase
end

endmodule