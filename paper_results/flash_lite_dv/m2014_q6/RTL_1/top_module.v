module top_module (
    input clk,
    input reset,
    input w,
    output z
);

    // State definition
    parameter A = 3'b000;
    parameter B = 3'b001;
    parameter C = 3'b010;
    parameter D = 3'b011;
    parameter E = 3'b100;
    parameter F = 3'b101;

    // State register
    reg [2:0] current_state, next_state;

    // Output z
    assign z = (current_state == E || current_state == F) ? 1'b1 : 1'b0;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: next_state = (w) ? A : B;
            B: next_state = (w) ? D : C;
            C: next_state = (w) ? D : E;
            D: next_state = (w) ? A : F;
            E: next_state = (w) ? D : E;
            F: next_state = (w) ? D : C;
            default: next_state = A; // Should never happen, but good practice
        endcase
    end

endmodule