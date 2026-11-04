module top_module (
    input clk,
    input reset,
    input w,
    output z
);

    // Define states using parameters for better readability and maintainability
    parameter A = 3'b000;
    parameter B = 3'b001;
    parameter C = 3'b010;
    parameter D = 3'b011;
    parameter E = 3'b100;
    parameter F = 3'b101;

    // State register
    reg [2:0] current_state;

    // Output register
    reg z;

    // State transition logic and state update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A; // Initialize to state A on reset
        end else begin
            case (current_state)
                A:  current_state <= (w) ? A : B;
                B:  current_state <= (w) ? D : C;
                C:  current_state <= (w) ? D : E;
                D:  current_state <= (w) ? A : F;
                E:  current_state <= (w) ? D : E;
                F:  current_state <= (w) ? D : C;
                default: current_state <= A; // Default state (should not happen, but good practice)
            endcase
        end
    end

    // Output logic
    always @(*) begin
        case (current_state)
            E, F:  z = 1;
            default: z = 0;
        endcase
    end

endmodule