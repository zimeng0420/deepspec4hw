module top_module (
	input clk,
	input in,
	input areset,
	output out
);

    parameter A = 2'b00;
    parameter B = 2'b01;

    reg [1:0] state, next_state;
    reg out_reg;

    // State transition logic
    always @(*) begin
        case (state)
            B: begin
                next_state = (in == 0) ? A : B;
            end
            A: begin
                next_state = (in == 0) ? B : A;
            end
            default: next_state = B; // Handle undefined states
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            A: out_reg = 0;
            B: out_reg = 1;
            default: out_reg = 1; //default output for safety
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output register
    assign out = out_reg;

endmodule