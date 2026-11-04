module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [1:0] count; // 2-bit counter to keep track of clock cycles

    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1; // Assert shift_ena
            count <= 2'b00; // Reset the counter
        end else if (count < 2'b11) begin
            count <= count + 1; // Increment the counter
            shift_ena <= 1; // Keep shift_ena asserted
        end else begin
            shift_ena <= 0; // Deassert shift_ena after 4 cycles
        end
    end

endmodule