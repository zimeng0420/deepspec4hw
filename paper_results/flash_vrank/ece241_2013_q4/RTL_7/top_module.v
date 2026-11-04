module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

  reg [1:0] prev_level; // Store the previous water level (0, 1, or 2 sensors asserted)

  // Define states for the previous level
  localparam LEVEL_NONE = 2'b00; // No sensors asserted
  localparam LEVEL_ONE  = 2'b01; // s[1] asserted
  localparam LEVEL_TWO  = 2'b10; // s[1], s[2] asserted
  localparam LEVEL_THREE = 2'b11; //s[1], s[2], s[3] asserted (Unused as previous level)

  always @(posedge clk) begin
    if (reset) begin
      fr3 <= 1'b1;
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      dfr <= 1'b0;
      prev_level <= LEVEL_NONE; 
    end else begin
      case (s)
        3'b111: begin // Above s[3]
          fr3 <= 1'b0;
          fr2 <= 1'b0;
          fr1 <= 1'b0;
          dfr <= 1'b0;
          prev_level <= LEVEL_THREE; //This won't effect the logic
        end
        3'b110: begin // Between s[3] and s[2]
          fr3 <= 1'b0;
          fr2 <= 1'b0;
          fr1 <= 1'b1;
          if (prev_level < LEVEL_TWO) begin
            dfr <= 1'b1;
          end else begin
            dfr <= 1'b0;
          end
          prev_level <= LEVEL_TWO;
        end
        3'b100: begin // Between s[2] and s[1]
          fr3 <= 1'b0;
          fr2 <= 1'b1;
          fr1 <= 1'b1;
          if (prev_level < LEVEL_ONE) begin
            dfr <= 1'b1;
          end else begin
            dfr <= 1'b0;
          end
          prev_level <= LEVEL_ONE;
        end
        default: begin // Below s[1] or no sensors asserted
          fr3 <= 1'b1;
          fr2 <= 1'b1;
          fr1 <= 1'b1;
          dfr <= 1'b0;
          prev_level <= LEVEL_NONE;
        end
      endcase
    end
  end

endmodule