module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    // State Definition
    parameter S0 = 2'b00; // Initial state, output = input
    parameter S1 = 2'b01; // Inversion state, output = NOT input

    // State Register (2 bits for 2 states)
    reg [1:0] current_state;
    reg first_one_seen; // Flag to track if the first '1' has been encountered

    // Next State Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S0;
            first_one_seen <= 1'b0;
        end else begin
            case (current_state)
                S0: begin
                    if (x) begin
                        current_state <= S1;
                        first_one_seen <= 1'b1;
                    end else begin
                        current_state <= S0;
                    end
                end
                S1: begin
                    current_state <= S1;
                end
                default: current_state <= S0; // Should not happen, but good practice
            endcase
        end
    end

    // Output Logic (Moore Machine)
    always @(*) begin
        case (current_state)
            S0: z = x;
            S1: z = ~x;
            default: z = x; // Should not happen, but good practice
        endcase
    end

endmodule