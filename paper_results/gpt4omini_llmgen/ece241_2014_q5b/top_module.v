module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);
    
    // State encoding using one-hot representation
    parameter STATE_A = 2'b01; // State A
    parameter STATE_B = 2'b10; // State B

    // State declaration
    reg [1:0] current_state, next_state;

    // Combinational logic for next state and output logic
    always @(*) begin
        z = 0; // Default output
        case (current_state)
            STATE_A: begin
                if (x) begin
                    next_state = STATE_B;
                    z = 1;
                end else begin
                    next_state = STATE_A;
                    z = 0;
                end
            end
            
            STATE_B: begin
                next_state = STATE_B; // Remain in State B
                z = x ? 0 : 1; // If x=1, z=0, else z=1
            end
            
            default: begin
                next_state = STATE_A; // Default case (should not occur)
                z = 0; // Default output
            end
        endcase
    end

    // Sequential logic for state transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_A; // Asynchronous reset to State A
        end else begin
            current_state <= next_state; // Update current state on clock edge
        end
    end

endmodule