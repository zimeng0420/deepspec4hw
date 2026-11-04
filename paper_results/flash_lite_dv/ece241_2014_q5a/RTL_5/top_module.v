module top_module(
    input clk,
    input areset,
    input x,
    output z
);

    // State Definition
    parameter S0 = 2'b00; // Initial state, output = x
    parameter S1 = 2'b01; // Inversion state, output = !x
    parameter S2 = 2'b10; // State after first '1', invert x
    parameter S3 = 2'b11;

    // Internal Signals
    reg [1:0] current_state;
    reg [1:0] next_state;
    reg found_one;

    // State Transition Logic (Next State Logic)
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
                next_state = S1;
            end
            default: next_state = S0;
        endcase
    end

    // State Register (Synchronous) - update on positive edge of clk, async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S0;
            found_one <= 1'b0;
        end else begin
            current_state <= next_state;
        end
    end

    // Output Logic (Combinational)
    always @(*) begin
        case (current_state)
            S0: z = x;
            S1: z = ~x;
            default: z = x;
        endcase
    end

endmodule