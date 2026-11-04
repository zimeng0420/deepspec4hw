module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding using one-hot encoding
    reg [1:0] state;
    reg [1:0] next_state;
    
    // Define states with one-hot encoding
    localparam A = 2'b01;
    localparam B = 2'b10;

    // Combinational logic for next state and output `z`
    always @(*) begin
        case (state)
            A: begin
                if (x == 0) begin
                    next_state = A; // Stay in A
                    z = 0; // Output z = 0
                end else begin
                    next_state = B; // Transition to B
                    z = 1; // Output z = 1
                end
            end
            B: begin
                if (x == 0) begin
                    next_state = B; // Stay in B
                    z = 1; // Output z = 1
                end else begin
                    next_state = B; // Stay in B
                    z = 0; // Output z = 0
                end
            end
            default: begin
                next_state = A; // Default to state A for safety
                z = 0; // Default output
            end
        endcase
    end

    // Sequential logic for state transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A; // Reset to state A
        end else begin
            state <= next_state;
        end
    end

endmodule