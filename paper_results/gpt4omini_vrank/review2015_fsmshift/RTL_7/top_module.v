module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [1:0] count; // 2-bit counter to count 4 cycles

    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1;
            count <= 2'd0; // Reset counter
        end else if (count < 2'd3) begin
            count <= count + 1; // Increment counter
            shift_ena <= 1; // Enable shift register
        end else begin
            shift_ena <= 0; // Disable shift register after 4 cycles
        end
    end

endmodule