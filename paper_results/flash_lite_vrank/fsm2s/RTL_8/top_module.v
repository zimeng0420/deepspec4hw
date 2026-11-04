module top_module (
	input clk,
	input j,
	input k,
	input reset,
	output out
);

    parameter OFF = 2'b00;
    parameter ON  = 2'b01;

    reg [1:0] state, next_state;
    reg out_reg;

    always @(posedge clk) begin
        if (reset)
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
                out_reg = 0;
            end
            ON: begin
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
                out_reg = 1;
            end
            default: begin
                next_state = OFF;
                out_reg = 0;
            end
        endcase
    end

    assign out = out_reg;

endmodule