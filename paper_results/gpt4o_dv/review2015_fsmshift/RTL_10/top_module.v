module top_module(
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] counter;  // 3-bit counter to count up to 4

    // Combinational logic for shift_ena output
    assign shift_ena = (counter < 4);

    // Sequential logic for the counter
    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;  // Initialize counter to 0 on reset
        end
        else if (counter < 4) begin
            counter <= counter + 1;  // Increment counter while it's less than 4
        end
    end

endmodule