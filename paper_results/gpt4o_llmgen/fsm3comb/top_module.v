module top_module (
	input in,
	input [1:0] state,
	output reg [1:0] next_state,
	output out
);

    // Define state encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // Combinational logic for state transitions
    always @(*) begin
        case (state)
            A: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            B: begin
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            C: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = D;
            end
            D: begin
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            default: next_state = A; // Default case added for safety
        endcase
    end

    // Combinational logic for output
    assign out = (state == D) ? 1'b1 : 1'b0;

endmodule