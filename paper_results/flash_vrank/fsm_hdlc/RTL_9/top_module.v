module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err);

  reg [3:0] state;

  localparam S_RESET = 4'b0000;
  localparam S_0     = 4'b0001;
  localparam S_1     = 4'b0010;
  localparam S_11    = 4'b0011;
  localparam S_111   = 4'b0100;
  localparam S_1111  = 4'b0101;
  localparam S_11111 = 4'b0110;
  localparam S_111110= 4'b0111;
  localparam S_111111= 4'b1000;
  localparam S_1111110 = 4'b1001;
  localparam S_ERR   = 4'b1010;


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
          if (in == 1'b0) state <= S_0;
          else             state <= S_1;
        end
        S_0: begin
          if (in == 1'b0) state <= S_0;
          else             state <= S_1;
        end
        S_1: begin
          if (in == 1'b0) state <= S_0;
          else             state <= S_11;
        end
        S_11: begin
          if (in == 1'b0) state <= S_0;
          else             state <= S_111;
        end
        S_111: begin
          if (in == 1'b0) state <= S_0;
          else             state <= S_1111;
        end
        S_1111: begin
          if (in == 1'b0) state <= S_0;
          else             state <= S_11111;
        end
        S_11111: begin
          if (in == 1'b0) begin
            state <= S_111110;
          end else begin
            state <= S_111111;
          end
        end
        S_111110: begin
          disc <= 1;
          if (in == 1'b0) state <= S_0;
          else state <= S_1;
        end
        S_111111: begin
          if (in == 1'b0) begin
            state <= S_1111110;
          end else begin
            state <= S_ERR;
          end
        end
        S_1111110: begin
          flag <= 1;
          if (in == 1'b0) state <= S_0;
          else             state <= S_1;
        end
        S_ERR: begin
          err <= 1;
          if (in == 1'b0) state <= S_0;
          else             state <= S_ERR;
        end
        default: state <= S_RESET;
      endcase
    end
  end

endmodule