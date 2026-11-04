module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (~state) begin
        if (a == 0 && b == 1)
            state <= 1;
        else if (a == 1 && b == 1)
            state <= 0;
    end
    else begin
        if (a == 1 && b == 1)
            state <= 1;
        else if (a == 0 && b == 1)
            state <= 0;
    end
end

always @(*) begin
    if (~state) begin
        q = (~a & b) | (a & ~b);
    end
    else begin
        q = (a & b) | (~a & ~b);
    end
end

endmodule