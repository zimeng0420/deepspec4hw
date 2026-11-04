module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    reg ff_state;
    wire next_state;

    // State encoding: A = 0, B = 1

    // Combinational logic for next state
    assign next_state = (!ff_state & !in) | (ff_state & in);

    // Output logic
    assign out = ff_state;

    // Sequential logic for state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ff_state <= 1; // Reset to state B
        end else begin
            ff_state <= next_state;
        end
    end

endmodule