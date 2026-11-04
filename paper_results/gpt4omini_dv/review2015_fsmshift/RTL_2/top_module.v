module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] count; // 3-bit counter to count 4 clock cycles

    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1; // Assert shift_ena
            count <= 3'd0; // Reset the counter
        end else if (count < 3'd3) begin
            count <= count + 1; // Increment the counter
            shift_ena <= 1; // Keep shift_ena asserted
        end else begin
            shift_ena <= 0; // Deassert shift_ena after 4 cycles
        end
    end
endmodule