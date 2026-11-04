module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);
    reg [2:0] current_state, next_state;

    // State encoding
    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;

    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= A; // Asynchronous reset to state A
        else 
            current_state <= next_state; // Transition to next state
    end

    always @(*) begin
        // Default next state
        next_state = current_state;
        z = 0; // Default output

        case (current_state)
            A: begin
                if (w == 0) next_state = B; 
                // z remains 0
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
                if (w == 1) next_state = D; 
                // z = 1 when in state E
                z = 1;
            end
            F: begin
                if (w == 0) next_state = C; 
                else next_state = D; 
            end
        endcase
    end
endmodule