module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);
    // State encoding
    typedef enum logic [1:0] {
        S0 = 2'b00, // Initial state
        S1 = 2'b01, // First '1' detected
        S2 = 2'b10  // Sequence '10' detected
    } state_t;

    state_t current_state, next_state;

    // State transition logic (sequential)
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0; // Asynchronous reset
        else
            current_state <= next_state; // Update state on clock edge
    end

    // Next state and output logic (combinational)
    always @(*) begin
        // Default values
        next_state = current_state;
        z = 1'b0;

        case (current_state)
            S0: begin
                if (x)
                    next_state = S1;
            end
            S1: begin
                if (!x)
                    next_state = S2;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // Sequence "101" detected
                end else
                    next_state = S0;
            end
        endcase
    end
endmodule