module top_module (
    input clock,
    input a,
    output reg p,
    output reg q
);

    always @(posedge clock) begin
        if (a) begin
            if (!p) begin
                p <= 1;
            end else if (p && !q) begin
                q <= 1;
            end
        end else begin
            p <= 0;
            q <= 0;
        end
    end

endmodule