module top_module (
	input clk,
	input areset,
	input x,
	output z
);

    parameter A = 4'b0001;
    parameter B = 4'b0010;
    
    reg [3:0] state;
    reg z_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            z_reg <= 1'b0;
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
            endcase
        end
    end

    assign z = z_reg;

endmodule