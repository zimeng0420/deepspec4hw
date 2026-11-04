module top_module(
    input clk,
    input reset,
    output shift_ena);

    reg [2:0] counter;
    reg shift_ena_r;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'b000;
            shift_ena_r <= 1'b1;
        end else begin
            if (counter < 3'b100 && shift_ena_r) begin
                counter <= counter + 3'b001;
                shift_ena_r <= 1'b1;
            end else begin
                counter <= counter;
                shift_ena_r <= 1'b0;
            end
        end
    end

    assign shift_ena = shift_ena_r;

endmodule