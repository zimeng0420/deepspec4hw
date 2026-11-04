module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);
    typedef enum reg [2:0] {
        A = 3'b000,
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100,
        F = 3'b101
    } state_t;

    state_t state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) 
            state <= A;
        else 
            state <= next_state;
    end

    always @(*) begin
        case(state)
            A: begin
                next_state = (w == 0) ? B : A;
                z = 0;
            end
            B: begin
                next_state = (w == 0) ? C : D;
                z = 0;
            end
            C: begin
                next_state = (w == 0) ? E : D;
                z = 0;
            end
            D: begin
                next_state = (w == 0) ? F : A;
                z = 0;
            end
            E: begin
                next_state = (w == 0) ? E : D;
                z = 1;
            end
            F: begin
                next_state = (w == 0) ? C : D;
                z = 1;
            end
            default: begin
                next_state = A;
                z = 0;
            end
        endcase
    end
endmodule