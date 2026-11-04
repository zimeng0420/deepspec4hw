module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

  reg [1:0] current_state;
  reg [1:0] previous_state;

  // State definitions
  localparam STATE_BELOW_S1  = 2'b00; // Below s1 (None asserted)
  localparam STATE_BETWEEN_S2_S1 = 2'b01; // Between s2 and s1 (s1 asserted)
  localparam STATE_BETWEEN_S3_S2 = 2'b10; // Between s3 and s2 (s1 and s2 asserted)
  localparam STATE_ABOVE_S3  = 2'b11; // Above s3 (s1, s2, and s3 asserted)


  always @(posedge clk) begin
    if (reset) begin
      current_state <= STATE_BELOW_S1;
      previous_state <= STATE_BELOW_S1;
      fr1 <= 1'b1;
      fr2 <= 1'b1;
      fr3 <= 1'b1;
      dfr <= 1'b0;  // Initialize dfr to 0 after reset
    end else begin

      previous_state <= current_state;

      // State transitions based on sensor inputs
      if (!s[1]) begin
        current_state <= STATE_BELOW_S1;
      } else if (s[1] && !s[2]) begin
        current_state <= STATE_BETWEEN_S2_S1;
      } else if (s[1] && s[2] && !s[3]) begin
        current_state <= STATE_BETWEEN_S3_S2;
      } else begin
        current_state <= STATE_ABOVE_S3;
      end

      // Output logic based on current state
      case (current_state)
        STATE_BELOW_S1: begin
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
          dfr <= 1'b0; // Supplemental valve not needed at max flow.
        end
        STATE_BETWEEN_S2_S1: begin
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b0;

          // Supplemental flow if previous level was lower
          if (previous_state == STATE_BELOW_S1) begin
            dfr <= 1'b1;
          } else begin
            dfr <= 1'b0;
          end
        end
        STATE_BETWEEN_S3_S2: begin
          fr1 <= 1'b1;
          fr2 <= 1'b0;
          fr3 <= 1'b0;

          // Supplemental flow if previous level was lower
          if (previous_state == STATE_BETWEEN_S2_S1) begin
            dfr <= 1'b1;
          } else begin
            dfr <= 1'b0;
          end
        end
        STATE_ABOVE_S3: begin
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          dfr <= 1'b0; // Supplemental valve off when above S3.
        end
        default: begin // Should never happen, but good practice
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
          dfr <= 1'b0;
        end
      endcase
    end
  end

endmodule