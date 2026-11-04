module top_module (
	input clk,
	input in,
	input areset,
	output out
);

    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] state, next_state;
    reg out_reg;

    // State transition logic
    always @(*) begin
        case (state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A; // Should not happen, but good practice
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            A: out_reg = 0;
            B: out_reg = 0;
            C: out_reg = 0;
            D: out_reg = 1;
            default: out_reg = 0; // Should not happen, but good practice
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output register
    always @(posedge clk) begin
        out <= out_reg;
    end
endmodule