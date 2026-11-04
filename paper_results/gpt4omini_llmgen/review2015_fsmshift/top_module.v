module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [1:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            shift_ena <= 1; // Assert shift_ena high on reset
        end else if (counter < 3) begin
            if (shift_ena) begin
                counter <= counter + 1; // Count cycles while shift_ena is high
            end
        end else begin
            shift_ena <= 0; // Deassert shift_ena after 4 cycles
        end
    end

    always @(posedge clk) begin
        if (reset || (counter < 3 && shift_ena)) begin
            // Shift enable remains high until 4 cycles are counted
            shift_ena <= 1;
        end else begin
            counter <= (reset && counter == 3) ? 0 : counter; // Reset counter after 4 counts
        end
    end
endmodule