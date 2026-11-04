module top_module(
    input clk,
    input areset,
    input x,
    output z
);

    // State Definition
    parameter S0 = 2'b00; // Initial state: output = input
    parameter S1 = 2'b01; // Inversion state: output = !input

    // State Register
    reg [1:0] current_state, next_state;

    // Intermediate Signals
    reg found_one;

    // State Transition Logic (Synchronous)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S0;
            found_one <= 1'b0; // Reset found_one
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic (Combinational)
    always @(*) begin
        case (current_state)
            S0: begin
                if (x) begin
                    next_state = S1;
                    found_one = 1'b1;
                end else begin
                    next_state = S0;
                    found_one = 1'b0; // Keep found_one false unless x=1 in S0
                end
            end
            S1: begin
                next_state = S1;
            end
            default:
                next_state = S0;
        endcase
    end

    // Output Logic (Combinational, Moore Machine)
    always @(*) begin
        case (current_state)
            S0: z = x;
            S1: z = ~x;
            default: z = x; // Default to mirror the input in initial state
        endcase
    end

endmodule