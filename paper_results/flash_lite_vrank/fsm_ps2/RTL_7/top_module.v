module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output done
);

    parameter IDLE = 2'b00;
    parameter FIRST = 2'b01;
    parameter SECOND = 2'b10;
    parameter THIRD = 2'b11;

    reg [1:0] state, next_state;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            done_reg <= (next_state == THIRD);
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3])
                    next_state = FIRST;
                else
                    next_state = IDLE;
            end
            FIRST: begin
                next_state = SECOND;
            end
            SECOND: begin
                next_state = THIRD;
            end
            THIRD: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule