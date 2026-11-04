module top_module(
    input clk,
    input reset,
    output reg shift_ena
);
    
    reg [2:0] count; // Counter to keep track of the number of clock cycles
    
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b1; // Assert shift_ena on reset
            count <= 3'd0; // Reset counter
        end else if (count < 3'd4) begin
            count <= count + 1'b1; // Increment counter
            shift_ena <= 1'b1; // Keep shift_ena asserted
        end else begin
            shift_ena <= 1'b0; // Deassert shift_ena after 4 cycles
        end
    end
    
endmodule