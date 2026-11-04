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
                if (x) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                if (x) begin
                    next_state = B;
                end else begin
                    next_state = B;
                end
            end
            default: next_state = A;
        endcase
    end

    always @(*) begin
        case (state)
            A: begin
                if (x) begin
                    z_reg = 1'b1;
                end else begin
                    z_reg = 1'b0;
                end
            end
            B: begin
                z_reg = ~x;
            end
            default: z_reg = 1'b0;
        endcase
    end

    assign z = z_reg;

endmodule