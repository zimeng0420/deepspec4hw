module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output reg out
);

    parameter OFF = 2'b00;
    parameter ON  = 2'b01;

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            case (state)
                OFF: state <= (j) ? ON : OFF;
                ON:  state <= (k) ? OFF : ON;
                default: state <= OFF;
            endcase
    end

    always @(*) begin
        case (state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule