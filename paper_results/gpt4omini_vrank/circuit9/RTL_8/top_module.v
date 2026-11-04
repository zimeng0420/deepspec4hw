module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);
    always @(posedge clk) begin
        if (a) begin
            if (q == 6) 
                q <= 0;
            else 
                q <= q + 1;
        end
    end
    
    always @(negedge clk) begin
        if (!a) begin
            q <= q;
        end
    end
endmodule