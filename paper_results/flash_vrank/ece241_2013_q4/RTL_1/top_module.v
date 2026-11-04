module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

  reg [1:0] prev_level; // Store the previous water level: 00 (None), 01 (s1), 10 (s1 & s2), 11 (s1 & s2 & s3)

  always @(posedge clk) begin
    if (reset) begin
      fr3 <= 1'b1;
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      dfr <= 1'b0;
      prev_level <= 2'b00;
    end else begin
      case (s)
        3'b111: begin // Above s[3]
          fr3 <= 1'b0;
          fr2 <= 1'b0;
          fr1 <= 1'b0;
          dfr <= 1'b0;
          prev_level <= 3'b11;
        end
        3'b110: begin // Between s[3] and s[2]
          fr3 <= 1'b0;
          fr2 <= 1'b0;
          fr1 <= 1'b1;
          if (prev_level < 3'b10) begin
            dfr <= 1'b1;
          end else begin
            dfr <= 1'b0;
          end
          prev_level <= 3'b10;
        end
        3'b100: begin // Between s[2] and s[1]
          fr3 <= 1'b0;
          fr2 <= 1'b1;
          fr1 <= 1'b1;
          if (prev_level < 3'b01) begin
            dfr <= 1'b1;
          end else begin
            dfr <= 1'b0;
          end
          prev_level <= 3'b01;
        end
        default: begin // Below s[1]
          fr3 <= 1'b1;
          fr2 <= 1'b1;
          fr1 <= 1'b1;
          dfr <= 1'b0;
          prev_level <= 3'b00;
        end
      endcase
    end
  end

endmodule