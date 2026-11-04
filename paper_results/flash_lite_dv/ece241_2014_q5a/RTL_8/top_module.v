module top_module(
    input clk,
    input areset,
    input x,
    output z
);

    // State Definition
    parameter S0 = 2'b00; // Initial state: output = input
    parameter S1 = 2'b01; // Inversion state: output = !input
    parameter S2 = 2'b10; // State to hold '1' after first 1 (Not used but good practice)
    parameter S3 = 2'b11; // Not used

    // State Register
    reg [1:0] current_state, next_state;

    // Register to track if '1' is found
    reg found_one;

    // Asynchronous Reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S0;
            found_one <= 1'b0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (x) begin
                    next_state = S1;
                end else begin
                    next_state = S0;
                end
            end
            S1: begin
                next_state = S1; // Stay in inversion state
            end
            default:
                next_state = S0;
        endcase
    end

    // Output Logic (Moore)
    always @(*) begin
        case (current_state)
            S0: z = x;
            S1: z = ~x;
            default: z = x;
        endcase
    end

endmodule