module top_module (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

    always @(*) begin
        if ((!a & b & !c) || (c & d) || (a & !b & !c) || (a & b & !d)) begin
            out = 1;
        } else begin
            out = 0;
        }
    end

endmodule