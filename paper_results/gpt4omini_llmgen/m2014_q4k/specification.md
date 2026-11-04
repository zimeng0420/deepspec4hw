```verilog
module top_module (
    input clk,
    input resetn,
    input in,
    output reg out
);

// Internal signals
reg [3:0] shift_reg; // 4-bit shift register

// Synchronous process for D flip-flops with active-low synchronous reset
always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        shift_reg <= 4'b0000; // Reset the shift register to 0 when resetn is low
    end else begin
        shift_reg <= {shift_reg[2:0], in}; // Shift left and input new bit
    end
end

// Assign the output as the last bit of the shift register
assign out = shift_reg[3];

endmodule
```