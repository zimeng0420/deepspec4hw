module top_module (
    input clk,
    input d,
    input r,
    output logic q
);
    always_ff @(posedge clk) begin
        if (r)
            q <= 1'b0;  // Synchronous reset: Set q to 0 when r is high
        else
            q <= d;     // Store the value of d into q when r is low
    end
endmodule