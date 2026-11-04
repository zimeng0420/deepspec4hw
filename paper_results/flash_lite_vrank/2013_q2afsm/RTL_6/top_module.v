module top_module (
	input clk,
	input resetn,
	input [3:1] r,
	output [3:1] g
);

    // State declaration
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register
    reg [1:0] state, next_state;

    // Output register for grants
    reg [3:1] g_internal;

    // State flip-flops
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // State table
    always @(*) begin
        case (state)
            A: begin
                if (r[1])
                    next_state = B;
                else if (r[2])
                    next_state = C;
				else if (r[3])
					next_state = D;
                else
                    next_state = A;
            end
            B: begin
                if (r[1])
                    next_state = B;
                else
                    next_state = A;
            end
            C: begin
                if (r[2])
                    next_state = C;
                else
                    next_state = A;
            end
			D: begin
				if (r[3])
					next_state = D;
				else
					next_state = A;
			end
            default:
                next_state = A;
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            A: g_internal = 3'b000;
            B: g_internal = {1'b1, 1'b0, 1'b0};
            C: g_internal = {1'b0, 1'b1, 1'b0};
			D: g_internal = {1'b0, 1'b0, 1'b1};
            default: g_internal = 3'b000;
        endcase
    end

	assign g = g_internal;

endmodule