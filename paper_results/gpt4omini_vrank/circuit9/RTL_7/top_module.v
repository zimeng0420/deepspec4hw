module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);
    always @(posedge clk) begin
        if (a) begin
            if (q == 0 || q == 6) 
                q <= 1;
            else if (q == 5) 
                q <= 0;
            else 
                q <= q + 1;
        end
    end

    initial begin
        q = 3'b000; // Initialize q to 0
    end
endmodule