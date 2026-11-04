module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

  reg [3:0] state; // 4 bits needed to represent up to 7 consecutive 1s + reset state

  localparam S_RESET = 4'b0000;
  localparam S_1     = 4'b0001;
  localparam S_2     = 4'b0010;
  localparam S_3     = 4'b0011;
  localparam S_4     = 4'b0100;
  localparam S_5     = 4'b0101;
  localparam S_6     = 4'b0110;
  localparam S_7     = 4'b0111;
  localparam S_8_PLUS= 4'b1000; // Represents 8 or more consecutive 1s

  always_ff @(posedge clk) begin
    if (reset) begin
      state <= S_RESET;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end else begin
      case (state)
        S_RESET: begin
          if (in) begin
            state <= S_1;
          end else begin
            state <= S_RESET;
          end
          disc <= 0;
          flag <= 0;
          err <= 0;
        end
        S_1: begin
          if (in) begin
            state <= S_2;
          end else begin
            state <= S_RESET;
          end
          disc <= 0;
          flag <= 0;
          err <= 0;
        end
        S_2: begin
          if (in) begin
            state <= S_3;
          end else begin
            state <= S_RESET;
          end
          disc <= 0;
          flag <= 0;
          err <= 0;
        end
        S_3: begin
          if (in) begin
            state <= S_4;
          end else begin
            state <= S_RESET;
          end
          disc <= 0;
          flag <= 0;
          err <= 0;
        end
        S_4: begin
          if (in) begin
            state <= S_5;
          end else begin
            state <= S_RESET;
          end
          disc <= 0;
          flag <= 0;
          err <= 0;
        end
        S_5: begin
          if (in) begin
            state <= S_6;
          end else begin
            state <= S_RESET;
          end
          disc <= 0;
          flag <= 0;
          err <= 0;
        end
        S_6: begin
          if (in) begin
            state <= S_7;
            flag <= 0;
            disc <= 1;
            err <= 0;
          end else begin
            state <= S_RESET;
            flag <= 1;
            disc <= 0;
            err <= 0;
          end
        end
        S_7: begin
          if (in) begin
            state <= S_8_PLUS;
            flag <= 0;
            disc <= 0;
            err <= 1;
          end else begin
            state <= S_RESET;
            flag <= 0;
            disc <= 0;
            err <= 1;
          end
        end
        S_8_PLUS: begin
          if (in) begin
            state <= S_8_PLUS;
          end else begin
            state <= S_RESET;
          end
          disc <= 0;
          flag <= 0;
          err <= 1;
        end
        default: begin
          state <= S_RESET;
          disc <= 0;
          flag <= 0;
          err <= 0;
        end
      endcase
    end
  end
endmodule