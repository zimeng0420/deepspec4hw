module top_module (
	input clk,
	input areset,
	input x,
	output z
);

    parameter A = 3'b001;
    parameter B = 3'b010;

    reg [2:0] state, next_state;

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
                    z = 1'b1;
                else
                    z = 1'b0;
            end
            B:
                z = 1'b1;
            default:
                z = 1'b0;
        endcase
    end

endmodule