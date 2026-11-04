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
                if (a == 1'b0 && b == 1'b1) begin
                    state <= 1'b1;
                end
                q <= (a & ~b) | (~a & b);
            end
            1'b1: begin
                if (a == 1'b1 && b == 1'b1) begin
                    state <= 1'b0;
                end
                q <= (a & b) | (~a & ~b);
            end
        endcase
    end

endmodule