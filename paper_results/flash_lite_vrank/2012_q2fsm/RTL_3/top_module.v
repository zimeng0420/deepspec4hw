module top_module (
	input clk,
	input reset,
	input w,
	output z
);

    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;

    reg [2:0] state, next_state;
    reg z_reg;

    // State Flip-Flops
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        case (state)
            A: begin
                next_state = (w) ? B : A;
            end
            B: begin
                next_state = (w) ? C : D;
            end
            C: begin
                next_state = (w) ? E : D;
            end
            D: begin
                next_state = (w) ? F : A;
            end
            E: begin
                next_state = (w) ? E : D;
            end
            F: begin
                next_state = (w) ? C : D;
            end
            default:
                next_state = A;
        endcase
    end

    // Output Logic
    always @(*) begin
        case (state)
            A: z_reg = 0;
            B: z_reg = 0;
            C: z_reg = 0;
            D: z_reg = 0;
            E: z_reg = 1;
            F: z_reg = 1;
            default: z_reg = 0;
        endcase
    end

    assign z = z_reg;

endmodule