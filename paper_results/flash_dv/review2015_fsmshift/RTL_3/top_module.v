module top_module(
    input clk,
    input reset,
    output shift_ena
);

reg [2:0] count;
reg shift_ena_r;

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
        shift_ena_r <= 1'b1;
    end else begin
        if (count < 4) begin
            shift_ena_r <= 1'b1;
            count <= count + 1;
        end else begin
            shift_ena_r <= 1'b0;
        end
    end
end

assign shift_ena = shift_ena_r;

endmodule