module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

  reg [3:0] state;

  localparam S_RESET = 4'b0000;
  localparam S_0     = 4'b0001;
  localparam S_1     = 4'b0010;
  localparam S_11    = 4'b0011;
  localparam S_111   = 4'b0100;
  localparam S_1111  = 4'b0101;
  localparam S_11111 = 4'b0110;
  localparam S_111111= 4'b0111;
  localparam S_ERROR = 4'b1000;

  always @(posedge clk) begin
    if (reset) begin
      state <= S_RESET;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end else begin
      disc <= 0;
      flag <= 0;
      err <= 0;

      case (state)
        S_RESET: begin
          if (in) begin
            state <= S_1;
          end else begin
            state <= S_0;
          end
        end
        S_0: begin
          if (in) begin
            state <= S_1;
          end else begin
            state <= S_0;
          end
        end
        S_1: begin
          if (in) begin
            state <= S_11;
          end else begin
            state <= S_0;
          end
        end
        S_11: begin
          if (in) begin
            state <= S_111;
          end else begin
            state <= S_0;
          end
        end
        S_111: begin
          if (in) begin
            state <= S_1111;
          end else begin
            state <= S_0;
          end
        end
        S_1111: begin
          if (in) begin
            state <= S_11111;
          end else begin
            state <= S_0;
          end
        end
        S_11111: begin
          if (in) begin
            state <= S_111111;
          end else begin
            state <= S_0;
            disc <= 1;
          end
        end
        S_111111: begin
          if (in) begin
            state <= S_ERROR;
            err <= 1;
          end else begin
            state <= S_0;
            flag <= 1;
          end
        end
        S_ERROR: begin
          if (in) begin
            state <= S_ERROR;
            err <= 1;
          end else begin
            state <= S_0;
          end
        end
        default: state <= S_RESET;
      endcase
    end
  end

endmodule