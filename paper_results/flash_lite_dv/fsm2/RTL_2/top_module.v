module top_module(
    input clk,
    input j,
    input k,
    input areset,
    output out
);

    // Define states
    parameter OFF = 2'b00;
    parameter ON = 2'b01;

    // State register
    reg [1:0] state;

    // Output register
    reg out;

    // Combinational logic for output
    always_comb begin
        case (state)
            OFF: out = 1'b0;
            ON: out = 1'b1;
            default: out = 1'b0; // Handle any unexpected states
        endcase
    end

    // State transition logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: state <= (j) ? ON : OFF;
                ON: state <= (k) ? OFF : ON;
                default: state <= OFF; // Handle any unexpected states
            endcase
        end
    end

endmodule