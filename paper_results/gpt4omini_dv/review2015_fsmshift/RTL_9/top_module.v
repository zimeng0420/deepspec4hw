module top_module(
    input clk,
    input reset,
    output reg shift_ena
);
    reg [1:0] count; // 2-bit counter to count clock cycles

    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b1; // Assert shift_ena
            count <= 2'b00; // Initialize count
        end else if (count < 2'b11) begin
            count <= count + 1'b1; // Increment count
            shift_ena <= 1'b1; // Maintain shift_ena high for 4 cycles
        end else begin
            shift_ena <= 1'b0; // Deassert shift_ena after 4 cycles
        end
    end
endmodule