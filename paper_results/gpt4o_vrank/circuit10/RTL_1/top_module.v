module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output state
);

    reg ff;
    
    assign state = ff;
    
    always @(posedge clk) begin
        if (a == 1 && b == 1)
            ff <= ~ff;
        else if (a == 1 && b == 0)
            ff <= 1'b0;
        else if (a == 0 && b == 1)
            ff <= 1'b1;
        // Else, keep the current state
    end
    
    always @(posedge clk) begin
        q <= ff;
    end

endmodule