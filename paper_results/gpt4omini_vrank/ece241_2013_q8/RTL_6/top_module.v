module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00,  // Initial state
        S1 = 2'b01,  // After '1'
        S2 = 2'b10   // After '10'
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset and state transition
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= S0;
            z <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (x) next_state = S1; // Input '1'
                else next_state = S0; 
                z = 0;
            end
            S1: begin
                if (x) next_state = S1; // Input '1'
                else next_state = S2; // Input '0'
                z = 0;
            end
            S2: begin
                if (x) begin
                    next_state = S1; // Input '1'
                    z = 1; // Detected "101"
                end else begin
                    next_state = S0; // Input '0'
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