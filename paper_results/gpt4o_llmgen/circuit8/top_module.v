module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);

    always @(posedge clock) begin
        if (a)
            p <= 1;
        else
            p <= 0;
    end

    always @(posedge clock or negedge clock) begin
        if (p == 1)
            q <= 0;
        else if (p == 0 && a)
            q <= 1;
        else
            q <= q;
    end

endmodule