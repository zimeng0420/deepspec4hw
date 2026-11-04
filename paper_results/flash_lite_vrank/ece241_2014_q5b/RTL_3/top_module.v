module top_module (
	input clk,
	input areset,
	input x,
	output z
);

    parameter A = 3'b001;
    parameter B = 3'b010;
    parameter C = 3'b100; // Not used in this implementation

    reg [2:0] state;
    reg z_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            z_reg <= 1'b0; // Default output in reset
        end else begin
            case (state)
                A: begin
                    if (x) begin
                        state <= B;
                        z_reg <= 1'b1;
                    end else begin
                        state <= A;
                        z_reg <= 1'b0;
                    end
                end
                B: begin
                    if (x) begin
                        state <= B;
                        z_reg <= 1'b0;
                    end else begin
                        state <= B;
                        z_reg <= 1'b1;
                    end
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