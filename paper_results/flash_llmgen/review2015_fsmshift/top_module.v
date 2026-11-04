module top_module(
    input clk,
    input reset,
    output shift_ena
);

  reg [1:0] counter; // 2-bit counter to count up to 3 (4 cycles)
  reg shift_ena_r;

  always @(posedge clk) begin
    if (reset) begin
      counter <= 2'b00;
      shift_ena_r <= 1'b1;
    end else begin
      if (counter < 2'b11) begin // Less than 3
        counter <= counter + 2'b01;
        shift_ena_r <= 1'b1;
      end else begin
        counter <= 2'b11; // Keep at 3
        shift_ena_r <= 1'b0;
      end
    end
  end

  assign shift_ena = shift_ena_r;

endmodule