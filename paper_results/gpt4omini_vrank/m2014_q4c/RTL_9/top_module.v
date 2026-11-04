module top_module (
    input clk,
    input d,
    input r,
    output logic q
);
    always_ff @(posedge clk) begin
        if (r) begin
            q <= 0; // Reset output to 0
        end else begin
            q <= d; // Load data on clock edge
        end
    end
endmodule