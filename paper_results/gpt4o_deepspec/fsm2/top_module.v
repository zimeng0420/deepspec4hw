module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);

    // State Encoding
    typedef enum reg [0:0] {
        OFF = 1'b0,
        ON  = 1'b1
    } state_t;

    state_t state, next_state;

    // State Transition Logic (Sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) 
            state <= OFF; // Asynchronous reset to OFF state
        else 
            state <= next_state; // Update state on clock edge
    end

    // Next-State Logic (Combinational)
    always @(*) begin
        case (state)
            OFF: next_state = (j == 1) ? ON : OFF; // Transition based on input j
            ON:  next_state = (k == 1) ? OFF : ON; // Transition based on input k
            default: next_state = OFF; // Default case for robustness
        endcase
    end

    // Output Logic (Combinational)
    always @(*) begin
        case (state)
            OFF: out = 1'b0; // Output for OFF state
            ON:  out = 1'b1; // Output for ON state
            default: out = 1'b0; // Default output in case of unexpected state
        endcase
    end

endmodule