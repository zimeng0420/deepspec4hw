module top_module (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

    always @(*) begin
        if ((!c && !d && a) || (!c && !d && b) ||
            (!c && d && b) || (!c && d && a) ||
            (c && d && !b) || (c && d && a) ||
            (c && !d && !b) || (c && !d && a) ||
            (b && c && d) || (b && c && !d) || (a && !b && !c && !d))
            out = 1;
        else
            out = 0;
    end

endmodule