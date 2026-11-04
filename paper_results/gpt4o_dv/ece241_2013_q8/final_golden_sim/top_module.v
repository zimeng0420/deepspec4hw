module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    typedef enum reg [1:0] {S0 = 2'b00, S1 = 2'b01, S2 = 2'b10} state_t;
    state_t current_state, next_state;

    // Asynchronous reset and state transition
    always @(negedge aresetn or posedge clk) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state and output logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (x) next_state = S1;
                else next_state = S0;
                z = 0;
            end
            S1: begin
                if (!x) next_state = S2;
                else next_state = S1;
                z = 0;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1;
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