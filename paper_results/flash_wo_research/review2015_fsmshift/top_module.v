module top_module(
    input clk,
    input reset,
    output shift_ena
);

reg [1:0] count;
reg shift_ena_r;

always @(posedge clk) begin
    if (reset) begin
        count <= 2'b00;
        shift_ena_r <= 1'b1;
    end else begin
        if (count < 2'b11) begin
            count <= count + 2'b01;
            shift_ena_r <= 1'b1;
        end else begin
            count <= 2'b11;
            shift_ena_r <= 1'b0;
        end
    end
end

assign shift_ena = shift_ena_r;

endmodule