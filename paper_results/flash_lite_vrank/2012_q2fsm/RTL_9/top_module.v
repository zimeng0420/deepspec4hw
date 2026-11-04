module top_module (
	input clk,
	input reset,
	input w,
	output z
);

    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;
    reg [2:0] state, next_state;
    reg z_reg;

    // State flip-flops
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // State table
    always @(*) begin
        case (state)
            A:  next_state = (w) ? B : A;
            B:  next_state = (w) ? C : D;
            C:  next_state = (w) ? E : D;
            D:  next_state = (w) ? F : A;
            E:  next_state = (w) ? E : D;
            F:  next_state = (w) ? C : D;
            default: next_state = A;
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            A:  z_reg = 0;
            B:  z_reg = 0;
            C:  z_reg = 0;
            D:  z_reg = 0;
            E:  z_reg = 1;
            F:  z_reg = 1;
            default: z_reg = 0;
        endcase
    end
    
    assign z = z_reg;

endmodule