module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;
    reg [2:0] current_state, next_state;

    // Combinational logic for next state
    always @(*) begin
        case (current_state)
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
            default: next_state = A; // Default case for safety
        endcase
    end

    // Sequential logic for state transition
    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= A;
        else 
            current_state <= next_state;
    end

    // Output logic
    always @(*) begin
        case (current_state)
            E, F: z = 1;
            default: z = 0;
        endcase
    end
endmodule