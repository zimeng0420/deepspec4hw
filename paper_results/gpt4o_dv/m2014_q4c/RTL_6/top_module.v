module top_module (
    input clk,
    input d,
    input r,
    output logic q
);

    always_ff @(posedge clk) begin
        if (r) begin
            q <= 0; // Synchronous reset
        end else begin
            q <= d; // Store data
        end
    end

endmodule