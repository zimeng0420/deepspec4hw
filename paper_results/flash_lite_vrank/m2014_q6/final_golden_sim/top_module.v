module top_module (
    input clk,
    input reset,
    input w,
    output z
);

    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;
    reg [2:0] state;
    reg z_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z_reg <= 1'b0;
        end else begin
            case (state)
                A: begin
                    state <= (w) ? A : B;
                    z_reg <= 1'b0;
                end
                B: begin
                    state <= (w) ? D : C;
                    z_reg <= 1'b0;
                end
                C: begin
                    state <= (w) ? D : E;
                    z_reg <= 1'b0;
                end
                D: begin
                    state <= (w) ? A : F;
                    z_reg <= 1'b0;
                end
                E: begin
                    state <= (w) ? D : E;
                    z_reg <= 1'b1;
                end
                F: begin
                    state <= (w) ? D : C;
                    z_reg <= 1'b1;
                end
                default: begin
                    state <= A;
                    z_reg <= 1'b0;
                end
            endcase
        end
    end

    assign z = z_reg;

endmodule