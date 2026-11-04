module top_module (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    reg D; // Input to the flip-flop

    always @(*) begin
        if (L) begin
            D = R;
        end else begin
            if (E) begin
                D = w;
            end else begin
                D = Q;
            end
        end
    end

    always @(posedge clk) begin
        Q <= D;
    end

endmodule