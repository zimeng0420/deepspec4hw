module top_module(
    input clk,
    input d,
    output reg q
);

    reg d_a;
    
    always @(posedge clk) begin
        d_a <= d;
        q <= d_a;
    end

endmodule