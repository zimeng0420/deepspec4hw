module top_module(
    input clk,
    input reset,
    input w,
    output z
);

    // State Definition
    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;
    reg [2:0] current_state, next_state;

    // State Flip-Flops
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next State Logic and Output Logic
    always @(*) begin
        case (current_state)
            A:  begin
                next_state = (w) ? B : A;
            end
            B:  begin
                next_state = (w) ? C : D;
            end
            C:  begin
                next_state = (w) ? E : D;
            end
            D:  begin
                next_state = (w) ? F : A;
            end
            E:  begin
                next_state = (w) ? E : D;
            end
            F:  begin
                next_state = (w) ? C : D;
            end
            default: next_state = A;
        endcase
    end

    // Output Logic (Moore Machine)
    assign z = (current_state == E || current_state == F) ? 1 : 0;

endmodule