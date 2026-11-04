module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);

    // Define states
    parameter OFF = 0;
    parameter ON  = 1;

    // Define state register
    reg [0:0] state;

    // State transition logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: state <= (j) ? ON : OFF;
                ON:  state <= (k) ? OFF : ON;
                default: state <= OFF; // Handle potential undefined states
            endcase
        end
    end

    // Output logic (Combinational)
    always_comb begin
        case (state)
            OFF: out = 0;
            ON:  out = 1;
            default: out = 0; // Handle potential undefined states
        endcase
    end
endmodule