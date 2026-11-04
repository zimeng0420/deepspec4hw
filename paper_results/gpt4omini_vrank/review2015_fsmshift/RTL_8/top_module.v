module top_module(
    input clk,
    input reset,
    output reg shift_ena
);
    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1;
            count <= 2'b00;
        end else if (count < 2'b11) begin
            count <= count + 1;
        end else begin
            shift_ena <= 0;
        end
    end
endmodule