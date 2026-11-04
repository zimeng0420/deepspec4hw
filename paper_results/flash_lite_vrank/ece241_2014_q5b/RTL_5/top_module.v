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

    // State transition logic
    always @(*) begin
        case (state)
            A:
                next_state = x ? B : A;
            B:
                next_state = x ? B : B;
            default:
                next_state = A; // Should not happen, but good practice
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            A:
                z_reg = 1'b0;
            B:
                z_reg = 1'b1;
            default:
                z_reg = 1'b0; // Should not happen
        endcase
    end

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output register
    assign z = z_reg;

endmodule