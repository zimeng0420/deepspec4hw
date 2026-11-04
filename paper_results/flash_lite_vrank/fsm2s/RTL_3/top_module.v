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

    // State transition logic
    always @(*) begin
        case (state)
            OFF: begin
                next_state = (j) ? ON : OFF;
            end
            ON: begin
                next_state = (k) ? OFF : ON;
            end
            default: next_state = OFF;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        case (state)
            OFF: out_reg = 1'b0;
            ON:  out_reg = 1'b1;
            default: out_reg = 1'b0;
        endcase
    end

    assign out = out_reg;

endmodule