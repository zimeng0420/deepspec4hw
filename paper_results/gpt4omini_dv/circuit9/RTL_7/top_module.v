module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a == 1) begin
            // Hold current state
            q <= q;
        end else begin
            // Increment q on each rising edge when a is 0
            q <= (q + 1) % 8; // Increment with modulo 8
        end
    end

endmodule