module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);

  reg [2:0] prev_s; // Store previous sensor values

  always @(posedge clk) begin
    if (reset) begin
      fr3 <= 1;
      fr2 <= 1;
      fr1 <= 1;
      dfr <= 0;
      prev_s <= 3'b000; // Initialize previous state to low water level
    end else begin
      // Determine nominal flow rates based on current sensor values
      if (s[3] && s[2] && s[1]) begin // Above s[3]
        fr3 <= 0;
        fr2 <= 0;
        fr1 <= 0;
      } else if (s[2] && s[1] && !s[3]) begin // Between s[3] and s[2]
        fr3 <= 0;
        fr2 <= 0;
        fr1 <= 1;
      } else if (s[1] && !s[2] && !s[3]) begin // Between s[2] and s[1]
        fr3 <= 0;
        fr2 <= 1;
        fr1 <= 1;
      } else begin // Below s[1]
        fr3 <= 1;
        fr2 <= 1;
        fr1 <= 1;
      end

      // Determine supplemental flow rate based on previous and current sensor values
      if ({s[3], s[2], s[1]} > prev_s) begin
        dfr <= 1; // Increase flow rate if water level increased
      } else begin
        dfr <= 0; // Otherwise, maintain current flow rate
      end

      // Update previous sensor values
      prev_s <= {s[3], s[2], s[1]};
    end
  end

endmodule