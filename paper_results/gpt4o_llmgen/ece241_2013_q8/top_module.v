module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00,  // Initial state
        S1 = 2'b01,  // Detected first '1'
        S2 = 2'b10   // Detected "10"
    } state_t;

    state_t current_state, next_state;

    // Sequential logic for state transition
    always @(negedge aresetn or posedge clk) begin
        if (!aresetn)
            current_state <= S0; // Asynchronous reset to state S0
        else
            current_state <= next_state;
    end

    // Combinational logic for next state and output logic
    always @(*) begin
        // Default outputs and next state
        next_state = current_state;
        z = 1'b0;

        case (current_state)
            S0: begin
                if (x)
                    next_state = S1;
            end

            S1: begin
                if (~x)
                    next_state = S2;
            end

            S2: begin
                if (x) begin
                    z = 1'b1; // Output assignment in Mealy, transition causes output
                    next_state = S1;
                end else
                    next_state = S0;
            end

        endcase
    end

endmodule