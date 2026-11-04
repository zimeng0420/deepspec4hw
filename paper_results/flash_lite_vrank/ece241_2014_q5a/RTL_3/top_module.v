module top_module (
	input clk,
	input areset,
	input x,
	output z
);

    parameter S_IDLE = 2'b00;
    parameter S_SEARCH = 2'b01;
    parameter S_COMPLEMENT = 2'b10;

    reg [1:0] state, next_state;
    reg complement;
    reg z_reg;
    reg x_prev; // Store the previous value of x

    always @(posedge clk or negedge areset) begin
        if (!areset) begin
            state <= S_IDLE;
            z_reg <= 1'b0;
            x_prev <= 1'b0;
        end else begin
            state <= next_state;
            x_prev <= x;
        end
    end

    always @(*) begin
        next_state = state;
        z_reg = 1'b0; // Default output

        case (state)
            S_IDLE: begin
                if (!areset) begin
                    next_state = S_IDLE;
                    z_reg = 1'b0;
                end else begin
                    next_state = S_SEARCH;
                end
            end
            S_SEARCH: begin
                if (x == 1'b1) begin
                    next_state = S_COMPLEMENT;
                end else begin
                    next_state = S_SEARCH;
                    z_reg = x;
                end
            end
            S_COMPLEMENT: begin
                 next_state = S_COMPLEMENT;
                 z_reg = ~x;
            end
            default: begin
                next_state = S_IDLE;
                z_reg = 1'b0;
            end
        endcase
    end

    assign z = z_reg;

endmodule