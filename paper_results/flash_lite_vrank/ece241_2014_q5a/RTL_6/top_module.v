module top_module (
	input clk,
	input areset,
	input x,
	output z
);

    parameter S_START = 2'b00;
    parameter S_FIND_ONE = 2'b01;
    parameter S_COMPLEMENT = 2'b10;

    reg [1:0] state, next_state;
    reg complement;
    reg z_reg;

    always @(posedge clk or negedge areset) begin
        if (!areset)
            state <= S_START;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        complement = 1'b0;
        z_reg = x; // Default: output equals input.

        case (state)
            S_START: begin
                if (x) begin // If x is 1, transition to finding the least significant 1
                    next_state = S_FIND_ONE;
                    z_reg = x;
                end
                else begin // If x is 0, output 0.
                    z_reg = x;
                end
            end

            S_FIND_ONE: begin
                if (x) begin // Found the least significant 1. Output the one and transition to complementing phase.
                    next_state = S_COMPLEMENT;
                    z_reg = x;
                end
                else begin //Still looking for the 1, output the input
                    z_reg = x;
                end
            end

            S_COMPLEMENT: begin
                complement = 1'b1; // Complement the input.
                z_reg = ~x;
            end
            default: begin
                next_state = S_START;
                z_reg = 1'b0;
            end
        endcase
    end

    assign z = (complement) ? z_reg : z_reg;

endmodule