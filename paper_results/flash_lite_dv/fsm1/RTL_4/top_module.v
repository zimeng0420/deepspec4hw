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

    // Output Logic (Combinational)
    always @(*) begin
        case (state)
            A: out = 0;
            B: out = 1;
            default: out = 0; // Should not happen, but good practice
        endcase
    end

    // State Transition Logic (Sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B; // Asynchronous Reset to state B
        end else begin
            case (state)
                A: begin
                    if (in)
                        state <= A; // 1 -> A
                    else
                        state <= B; // 0 -> B
                end
                B: begin
                    if (in)
                        state <= B; // 1 -> B
                    else
                        state <= A; // 0 -> A
                end
            endcase
        end
    end

endmodule