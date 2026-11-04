module top_module (
	input clk,
	input j,
	input k,
	input reset,
	output out
);

    parameter OFF = 2'b00;
    parameter ON = 2'b01;

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
                out_reg = 1'b0;
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            ON: begin
                out_reg = 1'b1;
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            default: begin
                out_reg = 1'b0;
                next_state = OFF;
            end
        endcase
    end

    assign out = out_reg;

endmodule