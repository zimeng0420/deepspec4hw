module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    // Define states using parameters for readability and maintainability
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register
    reg [1:0] current_state;
    reg [1:0] next_state;

    // Output register
    reg out_reg;

    // Next state logic
    always_comb begin
        case (current_state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A; // Default to A
        endcase
    end

    // Output logic
    always_comb begin
        case (current_state)
            A, B, C: out_reg = 0;
            D: out_reg = 1;
            default: out_reg = 0; // Default output
        endcase
    end

    // State update and reset logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Output assignment
    assign out = out_reg;

endmodule