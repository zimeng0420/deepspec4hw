module top_module (
	input clk,
	input in,
	input areset,
	output out
);

    parameter A = 2'b00;
    parameter B = 2'b01;

    reg [1:0] state, next_state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            B:
                next_state = in ? B : A;
            A:
                next_state = in ? A : B;
            default:
                next_state = B; // Default to B for safety
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            A: out = 1'b0;
            B: out = 1'b1;
            default: out = 1'b1; // Default output
        endcase
    end

endmodule