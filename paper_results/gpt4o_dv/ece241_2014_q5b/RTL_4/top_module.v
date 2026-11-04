module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding with one-hot encoding
    reg [1:0] state, next_state;
    parameter A = 2'b01, B = 2'b10;

    // Combinational logic for next state and output
    always @(*) begin
        case (state)
            A: begin
                if (x) begin
                    next_state = B;
                    z = 1;
                end else begin
                    next_state = A;
                    z = 0;
                end
            end
            B: begin
                next_state = B; // Always stay in B
                if (x) begin
                    z = 0;
                end else begin
                    z = 1;
                end
            end
        endcase
    end

    // Sequential logic for state transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A; // Asynchronous reset to state A
        end else begin
            state <= next_state;
        end
    end

endmodule