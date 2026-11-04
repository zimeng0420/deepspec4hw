module top_module (
	input clk,
	input areset,
	input x,
	output z
);

    parameter A = 4'b0001;
    parameter B = 4'b0010;
    
    reg [3:0] state, next_state;
    reg z_reg;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            A: begin
                if (x)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (x)
                    next_state = B;
                else
                    next_state = B;
            end
            default: next_state = A;
        endcase
    end

    always @(*) begin
        case (state)
            A: begin
                if (x)
                    z_reg = 1'b1;
                else
                    z_reg = 1'b0;
            end
            B: begin
                if (x)
                    z_reg = 1'b0;
                else
                    z_reg = 1'b1;
            end
            default: z_reg = 1'b0;
        endcase
    end

    assign z = z_reg;

endmodule