module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);

    initial begin
        q = 3'bxxx; // undefined state at reset
    end
    
    always @(posedge clk) begin
        if (a == 1) begin
            // Hold value when a is high
            q <= q;
        end else begin
            // Increment q when a is low
            q <= (q + 1) % 8; // modulo 8 increment
        end
    end

endmodule