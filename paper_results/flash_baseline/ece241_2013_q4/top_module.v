module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

  reg [1:0] prev_level; // Store the previous water level

  // Define states for the water level
  localparam LEVEL_BELOW_S1 = 2'b00;
  localparam LEVEL_BETWEEN_S1_S2 = 2'b01;
  localparam LEVEL_BETWEEN_S2_S3 = 2'b10;
  localparam LEVEL_ABOVE_S3 = 2'b11;

  always @(posedge clk) begin
    if (reset) begin
      fr3 <= 1'b1;
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      dfr <= 1'b0;
      prev_level <= LEVEL_BELOW_S1;
    end else begin
      case (s)
        3'b111: begin // Above s[3]
          fr3 <= 1'b0;
          fr2 <= 1'b0;
          fr1 <= 1'b0;
          dfr <= 1'b0;
          prev_level <= LEVEL_ABOVE_S3;
        end
        3'b011: begin // Between s[3] and s[2]
          fr3 <= 1'b0;
          fr2 <= 1'b0;
          fr1 <= 1'b1;
          if (prev_level < LEVEL_BETWEEN_S2_S3) begin
            dfr <= 1'b1;
          end else begin
            dfr <= 1'b0;
          end
          prev_level <= LEVEL_BETWEEN_S2_S3;
        end
        3'b001: begin // Between s[2] and s[1]
          fr3 <= 1'b0;
          fr2 <= 1'b1;
          fr1 <= 1'b1;
          if (prev_level < LEVEL_BETWEEN_S1_S2) begin
            dfr <= 1'b1;
          end else begin
            dfr <= 1'b0;
          end
          prev_level <= LEVEL_BETWEEN_S1_S2;
        end
        default: begin // Below s[1]
          fr3 <= 1'b1;
          fr2 <= 1'b1;
          fr1 <= 1'b1;
          dfr <= 1'b0;
          prev_level <= LEVEL_BELOW_S1;
        end
      endcase
    end
  end

endmodule