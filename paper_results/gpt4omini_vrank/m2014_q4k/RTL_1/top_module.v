module top_module (
    input clk,
    input resetn,
    input in,
    output out
);
    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (!resetn)
            shift_reg <= 4'b0000; // active-low reset
        else
            shift_reg <= {shift_reg[2:0], in}; // shift left and input in
    end

    assign out = shift_reg[3]; // Output the MSB

endmodule