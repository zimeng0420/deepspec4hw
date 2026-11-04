module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    reg first_one_seen;
    reg z_reg; // Registered output for Moore machine

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            first_one_seen <= 0;
            z_reg <= 0;
        end else begin
            first_one_seen <= first_one_seen || x;
            z_reg <= (first_one_seen) ? (~x) : (x);
        end
    end

    assign z = z_reg;

endmodule