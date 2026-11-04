module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            if (q == 3'd4) begin
                q <= 3'd4;
            end else begin
                q <= q + 1;
            end
        end else begin
            if (q != 3'd0) begin
                q <= q - 1;
            end
        end
    end

    initial begin
        q = 3'bxxx; // Undefined state at time 0
    end

endmodule