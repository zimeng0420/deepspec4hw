module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);
    reg state, next_state;

    localparam A = 1'b0, B = 1'b1; // State encoding

    // Combinational logic for next state
    always @(*) begin
        case (state)
            A: begin
                if (in == 0)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (in == 0)
                    next_state = A;
                else
                    next_state = B;
            end
        endcase
    end

    // Sequential logic for state transition and output
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B; // Reset to state B
        end else begin
            state <= next_state; // Update state
        end
    end

    // Output logic
    always @(*) begin
        case (state)
            A: out = 1'b0;
            B: out = 1'b1;
        endcase
    end
endmodule