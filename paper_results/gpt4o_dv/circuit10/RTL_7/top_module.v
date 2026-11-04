module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    // State transition logic
    if (state == 0) begin
        if (a == 0 && b == 1)
            state <= 1;
        else if (a == 1 && b == 1)
            state <= 0;
    end else begin  // state == 1
        if (a == 0 && b == 0)
            state <= 0;
        else if (a == 1 && b == 1)
            state <= 1;
    end
end

always @(*) begin
    // Combinational logic to determine output q based on current state
    q = (state == 0) ? ((~a & b) | (a & ~b)) : ((a & b) | (~a & ~b));
end

endmodule