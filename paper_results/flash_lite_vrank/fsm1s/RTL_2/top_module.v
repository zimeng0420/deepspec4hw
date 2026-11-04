module top_module (
	input clk,
	input in,
	input reset,
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
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
            A: begin
                if (in)
                    next_state = A;
                else
                    next_state = B;
            end
            default: next_state = B; // Default to B for safety
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            B: out_reg = 1'b1;
            A: out_reg = 1'b0;
            default: out_reg = 1'b1; // Default to B
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Output register
    always @(posedge clk) begin
        out <= out_reg;
    end

endmodule