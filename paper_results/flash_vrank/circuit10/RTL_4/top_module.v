module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    reg q_reg;
    wire next_state;

    assign state = q_reg;
    assign q = q_reg;

    always @(posedge clk) begin
        q_reg <= next_state;
    end

    assign next_state = (~a & b) | (a & b & q_reg) | (~a & ~b & q_reg);
    //assign next_state = (a & b) ? 1 : ((~a & b) ? 1 : ((~a & ~b) ? q_reg : ((a&~b)? q_reg: q_reg)));
    //assign next_state = (a&b) | (~a&b) | ((~a)&(~b) & q_reg);

endmodule