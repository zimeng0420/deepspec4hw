module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00, // Initial state
        S1 = 2'b01, // First '1' in "101" detected
        S2 = 2'b10  // "10" in "101" detected
    } state_t;

    reg [1:0] current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            S0: if (x) next_state = S1;  else next_state = S0;
            S1: if (x) next_state = S1;  else next_state = S2;
            S2: if (x) next_state = S1;  else next_state = S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        z = (current_state == S2 && x);
    end

    // State register update (sequential)
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0; // Asynchronous reset
        else
            current_state <= next_state;
    end

endmodule