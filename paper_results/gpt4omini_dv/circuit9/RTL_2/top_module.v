module top_module (
    input clk,
    input a,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a == 1'b0) begin
            q <= (q + 1) % 8;
        end
    end

    initial begin
        q = 3'bxxx; // Undefined state at the beginning
    end

endmodule