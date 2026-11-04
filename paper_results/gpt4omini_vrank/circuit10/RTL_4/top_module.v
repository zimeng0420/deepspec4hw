module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    // State memory logic
    if (a && !b) begin
        q <= 1;
    end else if (!a && b) begin
        q <= 0;
    end

    // Combinational logic for state output
    if (q) begin
        state <= a && b;
    end else begin
        state <= 0;
    end
end

endmodule