module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    anyedge <= 0; // Default to no edge detected

    for (int i = 0; i < 8; i++) begin
        if (!prev_in[i] && in[i]) begin
            anyedge[i] <= 1; // Rising edge detected
        end
    end

    prev_in <= in; // Store current input for next cycle
end

endmodule