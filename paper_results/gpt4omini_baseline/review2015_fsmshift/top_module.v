module top_module(
    input clk,
    input reset,
    output reg shift_ena
);
    
    reg [2:0] count; // Count from 0 to 3 (4 cycles)
    
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b1; // Enable shift register
            count <= 3'b000; // Start counting
        end else if (count < 3'b011) begin
            count <= count + 1; // Increment count
        end else begin
            shift_ena <= 1'b0; // Disable shift register after 4 cycles
        end
    end

endmodule