module top_module (
	input clk,
	input areset,
	input x,
	output z
);

  // State definitions
  parameter S_INIT = 2'b00;
  parameter S_SEARCH_ONE = 2'b01;
  parameter S_COMPLEMENT = 2'b10;

  // Internal signals
  reg [1:0] state;
  reg complement;
  reg z_reg;

  // State register
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= S_INIT;
      complement <= 1'b0;
    end else begin
      case (state)
        S_INIT: begin
          if (!x) begin
            z_reg <= 1'b0;
          end else begin
            z_reg <= 1'b1;
            state <= S_SEARCH_ONE;
          end
        end
        S_SEARCH_ONE: begin
          if (x) begin
            z_reg <= 1'b1;
          end else begin
            z_reg <= 1'b0;
            state <= S_COMPLEMENT;
          end
        end
        S_COMPLEMENT: begin
          z_reg <= ~x;
        end
      endcase
    end
  end

  // Output assignment
  assign z = z_reg;

endmodule