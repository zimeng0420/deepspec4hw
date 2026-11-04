module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output out
);

    parameter OFF = 0;
    parameter ON  = 1;

    reg [1:0] state, next_state;
    reg out_r;

    // State transition logic
    always @(*) begin
        case (state)
            OFF:
                next_state = (j) ? ON : OFF;
            ON:
                next_state = (k) ? OFF : ON;
            default:
                next_state = OFF;
        endcase
    end

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        case (state)
            OFF: out_r = 1'b0;
            ON:  out_r = 1'b1;
            default: out_r = 1'b0;
        endcase
    end

    assign out = out_r;

endmodule