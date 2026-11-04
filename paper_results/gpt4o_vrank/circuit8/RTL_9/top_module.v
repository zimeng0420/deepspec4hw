module top_module (
    input clock,
    input a, 
    output reg p,
    output reg q
);

    reg state;

    always @(posedge clock) begin
        if (a) begin
            state <= 1;
        end 
        else begin
            state <= 0;
        end

        p <= state;

        if (state == 0 && a == 0) begin
            q <= 1'b0;
        end 
        else begin
            q <= 1'b1;
        end
    end

endmodule