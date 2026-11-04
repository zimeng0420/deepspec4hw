module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);

// State encoding
reg [2:0] current_state, next_state;
localparam A = 3'b000,
           B = 3'b001,
           C = 3'b010,
           D = 3'b011,
           E = 3'b100,
           F = 3'b101;

// State flip-flops
always @(posedge clk) begin
    if (reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// State table (next-state logic)
always @(*) begin
    case (current_state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A;
    endcase
end

// Output logic
always @(*) begin
    case (current_state)
        E, F: z = 1;
        default: z = 0;
    endcase
end

endmodule