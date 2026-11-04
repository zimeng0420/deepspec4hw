module top_module (
	input clk,
	input resetn,
	input [3:1] r,
	output [3:1] g
);

    // State Definition
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State Register
    reg [1:0] state, next_state;

    // Output Register
    reg [3:1] g_reg;

    // State Table
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
                next_state = A; // No Grant Condition on D
            end
            default:
                next_state = A;
        endcase
    end

    // State Flip-Flops
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Output Logic
    always @(*) begin
        case (state)
            A:
                g_reg = 3'b000;
            B:
                g_reg = {1'b1, 1'b0, 1'b0};
            C:
                g_reg = {1'b0, 1'b1, 1'b0};
            D:
                g_reg = {1'b0, 1'b0, 1'b1};
            default:
                g_reg = 3'b000;
        endcase
    end

    assign g = g_reg;

endmodule