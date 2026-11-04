module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] count; // 3-bit counter to count 4 cycles

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'b000; // reset counter
            shift_ena <= 1'b1; // assert shift_ena
        end else if (count < 3'b011) begin
            count <= count + 1'b1; // increment counter
            shift_ena <= 1'b1; // keep shift_ena asserted
        end else begin
            shift_ena <= 1'b0; // deassert shift_ena after 4 cycles
        end
    end
endmodule