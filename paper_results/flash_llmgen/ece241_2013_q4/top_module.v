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
  localparam STATE_BELOW_S1 = 2'b00;  // Below s[1]
  localparam STATE_S1_S2    = 2'b01;  // Between s[2] and s[1]
  localparam STATE_S2_S3    = 2'b10;  // Between s[3] and s[2]
  localparam STATE_ABOVE_S3   = 2'b11;  // Above s[3]

  always @(posedge clk) begin
    if (reset) begin
      current_state <= STATE_BELOW_S1;
      previous_state <= STATE_BELOW_S1; // Initialize previous state for correct dfr behavior after reset
      fr1 <= 1'b1;
      fr2 <= 1'b1;
      fr3 <= 1'b1;
      dfr <= 1'b1; // Reset also asserts dfr
    end else begin
      previous_state <= current_state;

      // State transition logic
      if (!s[1]) begin
        current_state <= STATE_BELOW_S1;
      end else if (s[1] && !s[2]) begin
        current_state <= STATE_S1_S2;
      end else if (s[1] && s[2] && !s[3]) begin
        current_state <= STATE_S2_S3;
      end else begin
        current_state <= STATE_ABOVE_S3;
      end

      // Output logic
      case (current_state)
        STATE_BELOW_S1: begin
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
        end
        STATE_S1_S2: begin
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b0;
        end
        STATE_S2_S3: begin
          fr1 <= 1'b1;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
        STATE_ABOVE_S3: begin
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
        default: begin // Should never happen, but good practice
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
        end
      endcase

      // Supplemental flow rate logic (dfr)
      if ((current_state > previous_state) && (reset == 0)) begin
        dfr <= 1'b1;
      end else begin
        dfr <= 1'b0;
      end
    end
  end

endmodule