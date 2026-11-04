module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output out
);

    parameter OFF = 2'b00;
    parameter ON = 2'b01;

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

    // Output logic
    always @(*) begin
        case (state)
            OFF:
                out_r = 1'b0;
            ON:
                out_r = 1'b1;
            default:
                out_r = 1'b0;
        endcase
    end

    // State register and output register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
            out_r <= 1'b0;
        end else begin
            state <= next_state;
            // out_r <= out_next; // Output is directly derived from state.
        end
    end

    assign out = out_r;

endmodule