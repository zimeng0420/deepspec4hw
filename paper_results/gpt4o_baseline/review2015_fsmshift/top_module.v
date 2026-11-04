module top_module(
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] count; // 3-bit counter to count 4 clock cycles
    reg shift_ena_reg;

    assign shift_ena = shift_ena_reg;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            shift_ena_reg <= 1'b1; // Enable shift for 4 cycles
        end else if (shift_ena_reg) begin
            if (count == 3'd3) begin
                shift_ena_reg <= 1'b0; // Disable after 4 cycles
            end else begin
                count <= count + 1'b1; // Increment the counter
            end
        end
    end

endmodule