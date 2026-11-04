module top_module (
    input clk,
    input a, 
    output reg q
);
    always @(posedge clk) begin
        if (a == 1) begin
            q <= 0; // when a is 1, reset q to 0
        end else begin
            q <= q; // retain the value of q
        end
    end

    always @(negedge clk) begin
        if (a == 1) begin
            q <= 0; // when a is 1, reset q to 0
        end
    end
endmodule