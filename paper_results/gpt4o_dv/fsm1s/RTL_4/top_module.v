module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State encoding
    reg current_state, next_state;
    localparam B = 1'b0, A = 1'b1;

    // Next state logic
    always @(*) begin
        case (current_state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B;
        endcase
    end

    // State update logic
    always @(posedge clk) begin
        if (reset)
            current_state <= B; // Reset to state B
        else
            current_state <= next_state;
    end

    // Output logic
    always @(*) begin
        out = (current_state == B) ? 1'b1 : 1'b0;
    end

endmodule