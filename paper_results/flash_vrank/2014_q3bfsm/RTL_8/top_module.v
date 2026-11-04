module top_module (
	input clk,
	input reset,
	input x,
	output reg z
);

  reg [2:0] y;

  always @(posedge clk) begin
    if (reset) begin
      y <= 3'b000;
    end else begin
      case (y)
        3'b000: begin
          if (x == 0) begin
            y <= 3'b000;
          end else begin
            y <= 3'b001;
          end
        end
        3'b001: begin
          if (x == 0) begin
            y <= 3'b001;
          end else begin
            y <= 3'b100;
          end
        end
        3'b010: begin
          if (x == 0) begin
            y <= 3'b010;
          end else begin
            y <= 3'b001;
          end
        end
        3'b011: begin
          if (x == 0) begin
            y <= 3'b001;
          end else begin
            y <= 3'b010;
          end
        end
        3'b100: begin
          if (x == 0) begin
            y <= 3'b011;
          end else begin
            y <= 3'b100;
          end
        end
        default: y <= 3'b000; //should not happen, but good practice
      endcase
    end
  end

  always @(*) begin
    case (y)
      3'b000: z = 0;
      3'b001: z = 0;
      3'b010: z = 0;
      3'b011: z = 1;
      3'b100: z = 1;
      default: z = 0; //should not happen, but good practice
    endcase
  end

endmodule