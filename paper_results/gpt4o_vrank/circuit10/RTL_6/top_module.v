module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output state
);

    reg flip_flop;
    assign state = flip_flop;

    always @(posedge clk) begin
        if (a && b)
            flip_flop <= ~flip_flop;
        else if (b)
            flip_flop <= 1'b1;
        else if (a)
            flip_flop <= 1'b0;
        q <= flip_flop;
    end

endmodule