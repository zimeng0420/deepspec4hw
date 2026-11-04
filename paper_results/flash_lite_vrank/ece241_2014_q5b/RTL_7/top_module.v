module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    parameter A = 4'b0001;
    parameter B = 4'b0010;

    reg [3:0] state, next_state;
    reg z_reg;

    // State flip-flops
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        case (state)
            A: z_reg = 1'b0;
            B: z_reg = 1'b1;
            default: z_reg = 1'b0; // Should not happen, but good practice
        endcase
    end

    // Next state logic
    always @(*) begin
        case (state)
            A:
                next_state = (x == 1'b1) ? B : A;
            B:
                next_state = B;
            default:
                next_state = A; // Should not happen, but good practice
        endcase
    end

    assign z = z_reg;

endmodule