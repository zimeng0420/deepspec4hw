module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    // State Definition
    parameter S0 = 2'b00; // Initial state: output = input
    parameter S1 = 2'b01; // Inversion state: output = !input
    // Other states are not required.

    // State Register
    reg [1:0] current_state;
    reg first_one_found;

    // Output Register
    reg z_reg;

    // State Transition Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S0;
            first_one_found <= 1'b0; // Reset the flag
        end else begin
            case (current_state)
                S0: begin
                    if (x) begin
                        current_state <= S1; // Transition to S1 after the first '1'
                        first_one_found <= 1'b1;
                    end else begin
                        current_state <= S0; // Stay in S0 if input is '0'
                    end
                end
                S1: begin
                    current_state <= S1; // Stay in S1 after the first '1' has been found.
                end
                default:
                    current_state <= S0; // Default state
            endcase
        end
    end

    // Output Logic
    always @(*) begin
        case (current_state)
            S0:
                z_reg = x;
            S1:
                z_reg = ~x;
            default:
                z_reg = x; // Default case for robustness
        endcase
    end

    assign z = z_reg;

endmodule