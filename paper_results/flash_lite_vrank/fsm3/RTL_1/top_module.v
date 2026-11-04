module top_module (
	input clk,
	input in,
	input areset,
	output out
);

    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    reg [1:0] state, next_state;
    reg output_value;

    // State transition logic
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A; // Should never happen, but good practice
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            A, B, C: output_value = 0;
            D: output_value = 1;
            default: output_value = 0; // Default to 0
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
    assign out = output_value;

endmodule