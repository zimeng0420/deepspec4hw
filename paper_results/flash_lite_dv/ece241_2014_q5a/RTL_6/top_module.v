module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    // State Definition
    parameter S0 = 2'b00; // Initial state: output = input
    parameter S1 = 2'b01; // Inversion state: output = ~input
    parameter S2 = 2'b10; // State to find first 1
    parameter S3 = 2'b11; // All zeros encountered

    // State Register (2 bits for 4 states - although S2 and S3 are technically unused)
    reg [1:0] current_state, next_state;
    reg first_one_found; // Flag to track if the first '1' has been found

    // Output Register
    reg z_reg;

    // State Transition Logic (always block for next state)
    always @(*) begin
        case (current_state)
            S0: begin
                if (x == 1'b1)
                  next_state = S1;
                else
                  next_state = S0;
            end
            S1: begin
              next_state = S1;
            end
            S2: begin
                next_state = S2;
            end
            S3: begin
                next_state = S3;
            end
            default: next_state = S0; // Default case, should not happen
        endcase
    end

    // Output Logic
    always @(*) begin
        case (current_state)
            S0: z_reg = x;
            S1: z_reg = ~x;
            S2: z_reg = 1'b0; // Unused
            S3: z_reg = 1'b0; // Unused
            default: z_reg = 1'b0;
        endcase
    end

    // State Update and Output Assignment (synchronous)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S0;
            z_reg <= 1'b0;
        end else begin
            current_state <= next_state;
            z <= z_reg;
        end
    end

endmodule