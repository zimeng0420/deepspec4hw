module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] count; // 3-bit counter for 4 cycles

    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b1;  // Assert shift_ena
            count <= 3'd0;      // Reset counter
        end else if (count < 3'd3) begin
            count <= count + 1; // Increment count
            shift_ena <= 1'b1;  // Maintain shift_ena
        end else begin
            shift_ena <= 1'b0;  // Deassert shift_ena after 4 cycles
        end
    end

endmodule