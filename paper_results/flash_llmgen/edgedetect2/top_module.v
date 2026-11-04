module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] edge_detected;

always @(posedge clk) begin
    prev_in <= in; // Store the current input for the next cycle

    // Detect rising edges
    for (int i = 0; i < 8; i = i + 1) begin
        if (!prev_in[i] && in[i]) begin
            edge_detected[i] <= 1'b1;
        end else begin
            edge_detected[i] <= 1'b0;
        end
    end

    anyedge <= edge_detected; // Output the edge detection result
end

endmodule