module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output out
);

    parameter OFF = 0;
    parameter ON = 1;

    reg [1:0] state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            OFF: begin
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            ON: begin
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            default:
                next_state = OFF; // Should never happen, but good practice
        endcase
    end

    always @(*) begin
        case (state)
            OFF: out = 1'b0;
            ON: out = 1'b1;
            default: out = 1'b0; // Should never happen, but good practice
        endcase
    end

endmodule