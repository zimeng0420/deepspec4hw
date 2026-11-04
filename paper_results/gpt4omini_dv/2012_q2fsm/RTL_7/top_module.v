module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;
    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            A: next_state = (w) ? B : A; // A (0) --1--> B, A (0) --0--> A
            B: next_state = (w) ? C : D; // B (0) --1--> C, B (0) --0--> D
            C: next_state = (w) ? E : D; // C (0) --1--> E, C (0) --0--> D
            D: next_state = (w) ? F : A; // D (0) --1--> F, D (0) --0--> A
            E: next_state = (w) ? E : D; // E (1) --1--> E, E (1) --0--> D
            F: next_state = (w) ? C : D; // F (1) --1--> C, F (1) --0--> D
            default: next_state = A;     // Default to state A
        endcase
    end

    // State flip-flops
    always @(posedge clk) begin
        if (reset) 
            state <= A; // Reset to state A
        else 
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        case (state)
            E, F: z = 1; // z = 1 when in states E or F
            default: z = 0; // z = 0 otherwise
        endcase
    end

endmodule