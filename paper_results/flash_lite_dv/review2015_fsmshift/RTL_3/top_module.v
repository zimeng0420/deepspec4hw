module top_module(
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] count;
    reg shift_ena_reg;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            shift_ena_reg <= 1; // Assert shift_ena for the first cycle after reset
        end else begin
            if (count < 3 && shift_ena_reg) begin
                count <= count + 1;
            end else begin
                shift_ena_reg <= 0;
            end
        end
    end

    assign shift_ena = shift_ena_reg;

endmodule