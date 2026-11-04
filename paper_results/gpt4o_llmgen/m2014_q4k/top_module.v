module top_module (
    input clk,
    input resetn,
    input in,
    output reg out
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (!resetn)
            shift_reg <= 4'b0000;        // Synchronous active-low reset
        else
            shift_reg <= {shift_reg[2:0], in}; // Shift operation
    end

    always @(posedge clk) begin
        out <= shift_reg[3];   // Assign the output to the MSB of shift_reg
    end

endmodule