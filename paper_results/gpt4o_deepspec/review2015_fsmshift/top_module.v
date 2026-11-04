module top_module(
    input clk,
    input reset,
    output shift_ena
);
    reg [2:0] counter; // 3-bit counter to count clock cycles
    reg shift_ena_reg; // Register to hold the value of shift_ena

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;          // Reset counter to 0
            shift_ena_reg <= 1'b1;   // Assert shift_ena for the first cycle
        end else if (counter < 3'd4) begin
            counter <= counter + 1;  // Increment counter until it reaches 4
            shift_ena_reg <= 1'b1;   // Keep shift_ena asserted
        end else begin
            shift_ena_reg <= 1'b0;   // Deassert shift_ena after 4 cycles
        end
    end

    assign shift_ena = shift_ena_reg; // Assign the registered output to the module output

endmodule