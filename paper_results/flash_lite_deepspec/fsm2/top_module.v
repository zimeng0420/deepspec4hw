module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output out
);

    parameter OFF = 2'b00;
    parameter ON  = 2'b01;

    reg [1:0] state;
    reg out_reg;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: state <= (j) ? ON : OFF;
                ON:  state <= (k) ? OFF : ON;
            endcase
        end
    end

    always_comb begin
        case (state)
            OFF: out_reg = 1'b0;
            ON:  out_reg = 1'b1;
            default: out_reg = 1'b0; // Default case for safety
        endcase
    end

    assign out = out_reg;

endmodule