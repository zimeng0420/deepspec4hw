module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] state, next_state;
    reg out_reg;

    // State transition logic
    always @(*) begin
        case (state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A;
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            A, B, C: out_reg = 0;
            D: out_reg = 1;
            default: out_reg = 0;
        endcase
    end

    // State register and output register
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out_reg <= 0;
        end else begin
            state <= next_state;
            out_reg <= out_reg; // redundant but good practice
        end
    end

    assign out = out_reg;

endmodule