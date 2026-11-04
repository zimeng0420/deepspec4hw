module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output reg out
);

always @(*) begin
    case (state)
        4'b0001: begin // State A
            if (in)
                next_state = 4'b0010; // Go to State B
            else
                next_state = 4'b0001; // Stay in State A
            out = 0;
        end
        4'b0010: begin // State B
            if (in)
                next_state = 4'b0010; // Stay in State B
            else
                next_state = 4'b0100; // Go to State C
            out = 0;
        end
        4'b0100: begin // State C
            if (in)
                next_state = 4'b1000; // Go to State D
            else
                next_state = 4'b0001; // Go to State A
            out = 0;
        end
        4'b1000: begin // State D
            if (in)
                next_state = 4'b0010; // Go to State B
            else
                next_state = 4'b0100; // Go to State C
            out = 1;
        end
        default: begin
            next_state = 4'b0001; // Default to State A
            out = 0;
        end
    endcase
end

endmodule