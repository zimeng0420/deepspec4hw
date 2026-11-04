module top_module (
	input clk,
	input j,
	input k,
	input areset,
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
                next_state = OFF;
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            OFF: out_reg = 1'b0;
            ON:  out_reg = 1'b1;
            default: out_reg = 1'b0;
        endcase
    end

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output register
    assign out = out_reg;

endmodule