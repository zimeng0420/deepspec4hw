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

    // Output register
    reg [3:1] g_internal;

    // State Table (combinational logic)
    always @(*) begin
        next_state = state;
        g_internal = 3'b000; // Default: no grants

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
                g_internal[1] = 1;
                if (r[1])
                    next_state = B;
                else
                    next_state = A;
            end
            C: begin
                g_internal[2] = 1;
                if (r[2])
                    next_state = C;
                else
                    next_state = A;
            end
            D: begin
                g_internal[3] = 1;
                next_state = A; // Device 3 only gets grant when alone, so no looping needed
            end
            default:
                next_state = A;
        endcase
    end

    // State flip-flops (sequential logic)
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Output Assignment
    assign g = g_internal;

endmodule