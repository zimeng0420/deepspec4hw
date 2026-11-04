module top_module (
	input clk,
	input areset,
	input x,
	output z
);

    // State Definition
    parameter S0 = 2'b00; // Initial state: output = input
    parameter S1 = 2'b01; // Inversion state: output = !input
    parameter S2 = 2'b10; // State after first '1' encountered, output = !input
    parameter S3 = 2'b11; // State after first '1' encountered, output = !input

    // State Register
    reg [1:0] current_state, next_state;
    reg first_one_found;

    // Output Register
    reg z;

    // State Transition Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S0;
            first_one_found <= 1'b0;
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
                next_state = S1;
            end
            default: next_state = S0;
        endcase
    end

    // Output Logic
    always @(*) begin
        case (current_state)
            S0: z = x;
            S1: z = ~x;
            default: z = x;
        endcase
    end

endmodule