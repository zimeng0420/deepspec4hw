module top_module(
    input clk,
    input d,
    output reg q
);

reg q_posedge;
reg q_negedge;
reg clk_prev;

always @(posedge clk) begin
    q_posedge <= d;
end

always @(negedge clk) begin
    q_negedge <= d;
end

always @(clk) begin
    if (clk != clk_prev) begin
        if (clk == 1'b1) begin
            q <= q_posedge;
        end else begin
            q <= q_negedge;
        end
        clk_prev <= clk;
    end
end

endmodule