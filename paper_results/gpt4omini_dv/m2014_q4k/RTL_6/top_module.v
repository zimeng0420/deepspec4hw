module top_module (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;  // 4-bit shift register

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0000; // Synchronous reset
        end else begin
            shift_reg <= {shift_reg[2:0], in}; // Shift operation
        end
    end

    assign out = shift_reg[3]; // Output from the last flip-flop

endmodule