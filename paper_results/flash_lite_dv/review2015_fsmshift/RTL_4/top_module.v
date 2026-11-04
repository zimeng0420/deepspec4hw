module top_module(
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;
    reg shift_ena_internal;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
            shift_ena_internal <= 1'b1; // Assert shift_ena immediately after reset
        end else if (shift_ena_internal) begin
            if (counter < 2'b11) begin // Count to 3 (4 cycles)
                counter <= counter + 1'b1;
            end else begin
                shift_ena_internal <= 1'b0; // De-assert after 4 cycles
            end
        end
    end

    assign shift_ena = shift_ena_internal;

endmodule