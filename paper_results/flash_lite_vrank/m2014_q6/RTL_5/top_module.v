module top_module (
	input clk,
	input reset,
	input w,
	output z
);

    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;
    reg [2:0] state;
    reg z_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z_reg <= 0;
        end else begin
            case (state)
                A: begin
                    if (w)
                        state <= A;
                    else
                        state <= B;
                    z_reg <= 0;
                end
                B: begin
                    if (w)
                        state <= D;
                    else
                        state <= C;
                    z_reg <= 0;
                end
                C: begin
                    if (w)
                        state <= D;
                    else
                        state <= E;
                    z_reg <= 0;
                end
                D: begin
                    if (w)
                        state <= A;
                    else
                        state <= F;
                    z_reg <= 0;
                end
                E: begin
                    if (w)
                        state <= D;
                    else
                        state <= E;
                    z_reg <= 1;
                end
                F: begin
                    if (w)
                        state <= D;
                    else
                        state <= C;
                    z_reg <= 1;
                end
                default: begin
                    state <= A;
                    z_reg <= 0;
                end
            endcase
        end
    end

    assign z = z_reg;

endmodule