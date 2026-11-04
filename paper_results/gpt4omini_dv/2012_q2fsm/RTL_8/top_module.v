module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State Encoding
    parameter A = 3'b000;
    parameter B = 3'b001;
    parameter C = 3'b010;
    parameter D = 3'b011;
    parameter E = 3'b100;
    parameter F = 3'b101;

    reg [2:0] state, next_state;

    // State Transition Logic
    always @(*) begin
        case (state)
            A: begin
                if (w) next_state = B;
                else next_state = A;
            end
            B: begin
                if (w) next_state = C;
                else next_state = D;
            end
            C: begin
                if (w) next_state = E;
                else next_state = D;
            end
            D: begin
                if (w) next_state = F;
                else next_state = A;
            end
            E: begin
                if (w) next_state = E;
                else next_state = D;
            end
            F: begin
                if (w) next_state = C;
                else next_state = D;
            end
            default: next_state = A; // Default state
        endcase
    end

    // State Flip-Flops
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A; // Reset to state A
        end else begin
            state <= next_state; // Update state
        end
    end

    // Output Logic
    always @(*) begin
        case (state)
            E, F: z = 1'b1; // z = 1 in states E and F
            default: z = 1'b0; // z = 0 in all other states
        endcase
    end

endmodule