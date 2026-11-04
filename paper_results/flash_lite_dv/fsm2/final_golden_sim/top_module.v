module top_module(
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);

    // State Definition
    parameter OFF = 2'b00;
    parameter ON = 2'b01;

    // State Register
    reg [1:0] state;

    // Next State Logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: state <= (j) ? ON : OFF;
                ON: state <= (k) ? OFF : ON;
                default: state <= OFF; // Default state
            endcase
        end
    end

    // Output Logic (Combinational)
    always_comb begin
        case (state)
            OFF: out = 1'b0;
            ON: out = 1'b1;
            default: out = 1'b0; // Default output
        endcase
    end

endmodule