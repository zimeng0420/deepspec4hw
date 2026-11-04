module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b1; // Assert shift_ena
            count <= 3'b000;   // Initialize count
        end else if (count < 3'b011) begin
            count <= count + 1; // Increment count if less than 4
            shift_ena <= 1'b1;   // Keep shift_ena asserted
        end else begin
            shift_ena <= 1'b0;   // Deassert shift_ena after 4 cycles
        end
    end
endmodule