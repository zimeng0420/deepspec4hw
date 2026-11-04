module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11, E = 2'b100, F = 2'b101;
    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            A: begin
                if (w == 1) next_state = B;
                else next_state = A;
            end
            B: begin
                if (w == 1) next_state = C;
                else next_state = D;
            end
            C: begin
                if (w == 1) next_state = E;
                else next_state = D;
            end
            D: begin
                if (w == 1) next_state = F;
                else next_state = A;
            end
            E: begin
                if (w == 1) next_state = E;
                else next_state = D;
            end
            F: begin
                if (w == 1) next_state = C;
                else next_state = D;
            end
            default: next_state = A; // Default to A for safety
        endcase
    end

    // State flip-flops
    always @(posedge clk) begin
        if (reset) 
            state <= A;
        else 
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        case (state)
            A: z = 0;
            B: z = 0;
            C: z = 0;
            D: z = 0;
            E: z = 1;
            F: z = 1;
            default: z = 0; // Default to 0 for safety
        endcase
    end

endmodule