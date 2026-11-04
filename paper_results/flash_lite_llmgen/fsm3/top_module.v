module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    // State Encoding (using parameters for readability and maintainability)
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State Register (2 bits)
    reg [1:0] state;

    // Output Register (1 bit)
    reg out;

    // Next State Logic
    always @(*) begin
        case (state)
            A:  if (in) state = B; else state = A;
            B:  if (in) state = B; else state = C;
            C:  if (in) state = D; else state = A;
            D:  if (in) state = B; else state = C;
            default: state = A; // Default to A for safety
        endcase
    end

    // Output Logic
    always @(*) begin
        case (state)
            A, B, C: out = 0;
            D: out = 1;
            default: out = 0; // Default output for safety
        endcase
    end

    // State Update with Asynchronous Reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A; // Asynchronous reset to state A
        end else begin
            state <= state; // Update state on clock edge
        end
    end

endmodule