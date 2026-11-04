module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

  reg [2:0] prev_s; // Store the previous sensor state
  reg prev_level_low;

  always @(posedge clk) begin
    if (reset) begin
      fr3 <= 1;
      fr2 <= 1;
      fr1 <= 1;
      dfr <= 0;
      prev_s <= 3'b000;
      prev_level_low <= 1;
    end else begin
      // Water Level Determination
      if (s[3] && s[2] && s[1]) begin // Above s[3]
        fr3 <= 0;
        fr2 <= 0;
        fr1 <= 0;
        dfr <= 0;
        prev_level_low <= 0;
      end else if (s[2] && s[1] && !s[3]) begin // Between s[3] and s[2]
        fr3 <= 0;
        fr2 <= 0;
        fr1 <= 1;
        if (!prev_s[2] && !prev_s[3]) begin
            dfr <= 1;
        end else begin
            dfr <= 0;
        end
        prev_level_low <= 0;
      end else if (s[1] && !s[2] && !s[3]) begin // Between s[2] and s[1]
        fr3 <= 0;
        fr2 <= 1;
        fr1 <= 1;
        if (!prev_s[1] && !prev_s[2] && !prev_s[3]) begin
            dfr <= 1;
        end else begin
            dfr <= 0;
        end
        prev_level_low <= 0;
      end else begin // Below s[1]
        fr3 <= 1;
        fr2 <= 1;
        fr1 <= 1;
        dfr <= 0;
        prev_level_low <= 1;
      end

      prev_s <= s; // Update previous sensor state
    end
  end

endmodule