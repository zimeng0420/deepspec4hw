module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);
    // State encoding
    typedef enum reg [1:0] {
        S0,  // Initial state
        S1,  // State after seeing '1'
        S2   // State after seeing '10'
    } state_t;
    
    state_t current_state, next_state;

    // Asynchronous reset and state transition
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // State transition logic for Mealy FSM
    always @(*) begin
        case (current_state)
            S0: begin
                if (x) begin
                    next_state = S1;
                    z = 0;
                end else begin
                    next_state = S0;
                    z = 0;
                end
            end
            S1: begin
                if (!x) begin
                    next_state = S2;
                    z = 0;
                end else begin
                    next_state = S1;
                    z = 0;
                end
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1; // Output is high when "101" is detected
                end else begin
                    next_state = S0;
                    z = 0;
                end
            end
            default: begin
                next_state = S0;
                z = 0;
            end
        endcase
    end
endmodule