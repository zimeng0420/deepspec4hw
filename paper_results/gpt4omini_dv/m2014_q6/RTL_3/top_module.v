module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);

    reg [2:0] current_state, next_state;

    // State encoding
    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;

    // State transition logic
    always @(*) begin
        case (current_state)
            A: next_state = (w == 0) ? B : A;
            B: next_state = (w == 0) ? C : D;
            C: next_state = (w == 0) ? E : D;
            D: next_state = (w == 0) ? F : A;
            E: next_state = (w == 0) ? E : D;
            F: next_state = (w == 0) ? C : D;
            default: next_state = A; // Default to state A
        endcase
    end

    // State update and output logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
            z <= 0;
        end else begin
            current_state <= next_state;
            z <= (current_state == E) ? 1 : 0; // z is high when in state E
        end
    end

endmodule