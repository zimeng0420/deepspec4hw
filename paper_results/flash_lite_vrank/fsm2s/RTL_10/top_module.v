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
    reg out_r;

    // State transition logic
    always @(*) begin
        case (state)
            OFF:  next_state = (j) ? ON  : OFF;
            ON:   next_state = (k) ? OFF : ON;
            default: next_state = OFF; // Default state
        endcase
    end

    // State register (synchronous)
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic (Moore)
    always @(*) begin
        case (state)
            OFF: out_r = 1'b0;
            ON:  out_r = 1'b1;
            default: out_r = 1'b0; // Default output
        endcase
    end

    assign out = out_r;

endmodule