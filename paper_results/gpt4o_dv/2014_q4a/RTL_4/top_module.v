module top_module (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin
        Q <= R; // Load operation
    end else if (E) begin
        Q <= w; // Shift operation
    end
    // Hold operation is implicit as Q retains its value if neither L nor E is asserted
end

endmodule