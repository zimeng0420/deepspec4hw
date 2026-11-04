module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State declaration using one-hot encoding
    typedef enum reg [1:0] {
        A = 2'b01,
        B = 2'b10
    } state_t;
    
    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            A: begin
                if (x) begin
                    next_state = B;
                    z = 1;
                end else begin
                    next_state = A;
                    z = 0;
                end
            end
            
            B: begin
                next_state = B; // Stay in B
                z = x ? 0 : 1; // z = 1 if x = 0, else z = 0
            end
            
            default: begin
                next_state = A; // Default state
                z = 0;
            end
        endcase
    end

    // State update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A; // Reset to state A
        end else begin
            current_state <= next_state; // Transition to next state
        end
    end
endmodule