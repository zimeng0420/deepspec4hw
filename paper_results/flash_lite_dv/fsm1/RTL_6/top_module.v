module top_module(
    input clk,
    input in,
    input areset,
    output out
);

    // State Definition
    parameter A = 0;
    parameter B = 1;

    // State Register
    reg state;

    // Combinational Logic for State Transition and Output
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B; // Asynchronous reset to state B
        end else begin
            case (state)
                A: begin
                    if (in)
                        state <= A; // A --1--> A
                    else
                        state <= B; // A --0--> B
                end
                B: begin
                    if (in)
                        state <= B; // B --1--> B
                    else
                        state <= A; // B --0--> A
                end
            endcase
        end
    end

    // Output Logic
    assign out = state;

endmodule