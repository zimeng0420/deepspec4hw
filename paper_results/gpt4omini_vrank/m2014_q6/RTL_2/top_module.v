module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);
    // State Encoding
    typedef enum reg [2:0] {
        A = 3'b000,
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100,
        F = 3'b101
    } state_t;

    state_t current_state, next_state;

    // State Transition Logic
    always @(*) begin
        case (current_state)
            A: begin
                if (w == 0) next_state = B;
                else next_state = A;
                z = 0;
            end
            B: begin
                if (w == 0) next_state = C;
                else next_state = D;
                z = 0;
            end
            C: begin
                if (w == 0) next_state = E;
                else next_state = D;
                z = 0;
            end
            D: begin
                if (w == 0) next_state = F;
                else next_state = A;
                z = 0;
            end
            E: begin
                if (w == 0) next_state = E;
                else next_state = D;
                z = 1;
            end
            F: begin
                if (w == 0) next_state = C;
                else next_state = D;
                z = 1;
            end
            default: next_state = A; // fallback to default state
        endcase
    end

    // State Update Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end
endmodule