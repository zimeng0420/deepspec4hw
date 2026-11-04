module top_module(
    input clk,
    input d,
    output reg q);

    reg [1:0] data;
    
    always @(posedge clk) begin
        data[0] <= d;
    end
    
    always @(negedge clk) begin
        data[1] <= d;
    end
    
    always @(*) begin
        q = clk ? data[0] : data[1];
    end

endmodule