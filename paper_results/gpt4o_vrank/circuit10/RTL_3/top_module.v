module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output state
);

    reg state_reg;

    always @(posedge clk) begin
        case ({a, b})
            2'b00: state_reg <= state_reg;       // Maintain the current state
            2'b01: state_reg <= 1'b0;            // Reset state
            2'b10: state_reg <= state_reg;       // Maintain the current state
            2'b11: state_reg <= ~state_reg;      // Toggle the state
        endcase
    end

    assign state = state_reg;
    assign q = state_reg;

endmodule