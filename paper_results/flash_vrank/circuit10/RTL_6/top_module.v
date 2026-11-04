module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    reg q_reg;
    assign q = q_reg;
    assign state = q_reg;

    always @(posedge clk) begin
        if (~a & ~b) begin
            q_reg <= 0;
        end else if (~a & b) begin
            q_reg <= 1;
        end else if (a & ~b) begin
            q_reg <= 0;
        end else if (a & b) begin
            q_reg <= ~q_reg;
        end 
    end

endmodule