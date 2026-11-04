module top_module (
    input clk,
    input d,
    input r,
    output logic q
);
    always_ff @(posedge clk) begin
        if (r) begin
            q <= 0;  // Asynchronous reset active high
        end else begin
            q <= d;  // Capture the data input on the rising edge of clk
        end
    end
endmodule