module top_module (
    input clk,
    input reset,
    input w,
    output z
);

    reg [2:0] current_state, next_state;  // 3 bits needed to represent 6 states

    // Define the states
    parameter A = 3'b000;
    parameter B = 3'b001;
    parameter C = 3'b010;
    parameter D = 3'b011;
    parameter E = 3'b100;
    parameter F = 3'b101;

    // State Transition Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            A: begin
                if (w == 0) next_state = B;
                else next_state = A;
            end
            B: begin
                if (w == 0) next_state = C;
                else next_state = D;
            end
            C: begin
                if (w == 0) next_state = E;
                else next_state = D;
            end
            D: begin
                if (w == 0) next_state = F;
                else next_state = A;
            end
            E: begin
                if (w == 0) next_state = E;
                else next_state = D;
            end
            F: begin
                if (w == 0) next_state = C;
                else next_state = D;
            end
            default: next_state = A; // Should not happen, but good practice
        endcase
    end

    // Output Logic (assuming z is high for state E)
    assign z = (current_state == E);

endmodule