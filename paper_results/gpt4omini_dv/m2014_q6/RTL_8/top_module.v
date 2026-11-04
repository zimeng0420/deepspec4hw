module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);

    typedef enum reg [2:0] {A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101} state_t;
    state_t current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= A;
        else 
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            A: next_state = (w == 0) ? B : A;
            B: next_state = (w == 0) ? C : D;
            C: next_state = (w == 0) ? E : D;
            D: next_state = (w == 0) ? F : A;
            E: next_state = (w == 0) ? E : D;
            F: next_state = (w == 0) ? C : D;
            default: next_state = A;  // default state
        endcase
    end

    always @(*) begin
        z = (current_state == E) ? 1 : 0;
    end

endmodule