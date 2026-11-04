module top_module (
    input clk,
    input a, 
    output reg q
);

    always @(posedge clk) begin
        if (clk == 1) begin
            if (a == 0) 
                q <= 1;
            else 
                q <= 0;
        end
    end

    always @(negedge clk) begin
        // Hold state when clk is low
        // No assignment needed as 'q' retains its value
    end

endmodule