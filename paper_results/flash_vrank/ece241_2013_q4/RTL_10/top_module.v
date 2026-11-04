module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

  reg [1:0] prev_level; // Store previous water level (00, 01, 10, 11 representing levels)

  // Define states for the FSM
  localparam LEVEL_BELOW_S1 = 2'b00;
  localparam LEVEL_BETWEEN_S1_S2 = 2'b01;
  localparam LEVEL_BETWEEN_S2_S3 = 2'b10;
  localparam LEVEL_ABOVE_S3 = 2'b11;

  reg [1:0] current_level;


  always @(posedge clk) begin
    if (reset) begin
      fr3 <= 1'b1;
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      dfr <= 1'b0;
      prev_level <= LEVEL_BELOW_S1; // Reset to low level state
      current_level <= LEVEL_BELOW_S1;

    end else begin

      // Determine current level
      if (!s[1]) begin
        current_level <= LEVEL_BELOW_S1;
      } else if (s[1] && !s[2]) begin
        current_level <= LEVEL_BETWEEN_S1_S2;
      } else if (s[2] && !s[3]) begin
        current_level <= LEVEL_BETWEEN_S2_S3;
      } else begin
        current_level <= LEVEL_ABOVE_S3;
      end

      // Determine flow rates based on current level
      case (current_level)
        LEVEL_BELOW_S1: begin
          fr3 <= 1'b1;
          fr2 <= 1'b1;
          fr1 <= 1'b1;
        end
        LEVEL_BETWEEN_S1_S2: begin
          fr3 <= 1'b0;
          fr2 <= 1'b1;
          fr1 <= 1'b1;
        end
        LEVEL_BETWEEN_S2_S3: begin
          fr3 <= 1'b0;
          fr2 <= 1'b0;
          fr1 <= 1'b1;
        end
        LEVEL_ABOVE_S3: begin
          fr3 <= 1'b0;
          fr2 <= 1'b0;
          fr1 <= 1'b0;
        end
        default: begin
          fr3 <= 1'b0;
          fr2 <= 1'b0;
          fr1 <= 1'b0;
        end
      endcase

      // Determine if supplemental flow valve should be opened
      if (current_level > prev_level) begin
          dfr <= 1'b1;
      } else begin
          dfr <= 1'b0;
      end

      prev_level <= current_level; // Update previous level
    end
  end

endmodule