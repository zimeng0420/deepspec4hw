module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State encoding
    localparam A = 1'b0, B = 1'b1;
    reg state, next_state;

    // Output logic (Moore machine)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B; // Reset state to B
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (in == 0) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                if (in == 0) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            default: next_state = B; // Default case to prevent latches
        endcase
    end

    // Output logic
    always @(state) begin
        out = state; // Output is the current state (1 for B, 0 for A)
    end

endmodule