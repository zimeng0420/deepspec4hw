module top_module (
	input clk,
	input reset,
	input w,
	output z
);

    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;
    reg [2:0] state, next_state;
    reg z_reg;

    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            A: begin
                if (w)
                    next_state = A;
                else
                    next_state = B;
                z_reg = 0;
            end
            B: begin
                if (w)
                    next_state = D;
                else
                    next_state = C;
                z_reg = 0;
            end
            C: begin
                if (w)
                    next_state = D;
                else
                    next_state = E;
                z_reg = 0;
            end
            D: begin
                if (w)
                    next_state = A;
                else
                    next_state = F;
                z_reg = 0;
            end
            E: begin
                if (w)
                    next_state = D;
                else
                    next_state = E;
                z_reg = 1;
            end
            F: begin
                if (w)
                    next_state = D;
                else
                    next_state = C;
                z_reg = 1;
            end
            default: begin
                next_state = A;
                z_reg = 0;
            end
        endcase
    end

    assign z = z_reg;

endmodule