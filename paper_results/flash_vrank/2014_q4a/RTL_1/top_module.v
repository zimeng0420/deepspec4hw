module top_module (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    reg D;

    always @(*) begin
        if (L) begin
            D = R;
        } else if (E) begin
            D = w;
        } else begin
            D = Q;
        end
    end

    always @(posedge clk) begin
        Q <= D;
    end

endmodule