module top_module (
	input clk,
	input reset,
	input [3:1] s,
	output reg fr3,
	output reg fr2,
	output reg fr1,
	output reg dfr
);

  reg [1:0] prev_level; // Stores the previous water level (0, 1, or 2 sensors asserted). 0 represents no sensor asserted
  reg [1:0] current_level;
  
  parameter LEVEL_NONE  = 2'b00;
  parameter LEVEL_ONE   = 2'b01;
  parameter LEVEL_TWO   = 2'b10;
  parameter LEVEL_THREE = 2'b11;

  always @(posedge clk) begin
    if (reset) begin
      fr3 <= 1'b1;
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      dfr <= 1'b0; // Ensure supplemental flow is initially off
      prev_level <= LEVEL_NONE;
      current_level <= LEVEL_NONE;
    end else begin
      // Determine the current water level based on sensor inputs.

      if (s[1] && s[2] && s[3]) begin
          current_level <= LEVEL_THREE;
      end else if (s[1] && s[2]) begin
          current_level <= LEVEL_TWO;
      end else if (s[1]) begin
          current_level <= LEVEL_ONE;
      end else begin
          current_level <= LEVEL_NONE;
      end
      
      // Nominal flow rate control
      case (current_level)
        LEVEL_THREE: begin
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
        LEVEL_TWO: begin
          fr1 <= 1'b1;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
        LEVEL_ONE: begin
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b0;
        end
        LEVEL_NONE: begin
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
        end
        default: begin
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            fr3 <= 1'b1;
        end
      endcase

      //Supplemental Flow Valve Control
      if (current_level > prev_level) begin
        dfr <= 1'b1; //Increase flow rate by opening supplimental valve
      end else begin
        dfr <= 1'b0; //Keep supplimental flow valve closed
      end

      prev_level <= current_level; // Update Previous Water Level
    end
  end
endmodule