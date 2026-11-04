module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

  reg [3:0] state;

  localparam S_IDLE  = 4'b0000;
  localparam S_1     = 4'b0001;
  localparam S_11    = 4'b0010;
  localparam S_111   = 4'b0011;
  localparam S_1111  = 4'b0100;
  localparam S_11111 = 4'b0101;
  localparam S_111110 = 4'b0110;
  localparam S_111111 = 4'b0111;
  localparam S_1111110 = 4'b1000;
  localparam S_1111111 = 4'b1001;
  localparam S_ERROR = 4'b1111;

  always @(posedge clk) begin
    if (reset) begin
      state <= S_IDLE;
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;
    end else begin
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;

      case (state)
        S_IDLE: begin
          if (in == 1'b1) begin
            state <= S_1;
          end else begin
            state <= S_IDLE;
          end
        end
        S_1: begin
          if (in == 1'b1) begin
            state <= S_11;
          end else begin
            state <= S_IDLE;
          end
        end
        S_11: begin
          if (in == 1'b1) begin
            state <= S_111;
          end else begin
            state <= S_IDLE;
          end
        end
        S_111: begin
          if (in == 1'b1) begin
            state <= S_1111;
          end else begin
            state <= S_IDLE;
          end
        end
        S_1111: begin
          if (in == 1'b1) begin
            state <= S_11111;
          end else begin
            state <= S_IDLE;
          end
        end
        S_11111: begin
          if (in == 1'b1) begin
            state <= S_111111;
          end else begin
            state <= S_IDLE;
          end
        end
        S_111111: begin
          if (in == 1'b0) begin
            state <= S_1111110;
            disc <= 1'b1;
          end else begin
            state <= S_1111111;
          end
        end
        S_1111110: begin
          state <= S_IDLE;
        end
        S_1111111: begin
          if (in == 1'b0) begin
            state <= S_IDLE;
            flag <= 1'b1;
          end else begin
            state <= S_ERROR;
          end
        end
        S_ERROR: begin
          if (in == 1'b1) begin
            state <= S_ERROR;
            err <= 1'b1;
          end else begin
            state <= S_IDLE;
            err <= 1'b1;
          end
        end
        default: begin
          state <= S_IDLE;
        end
      endcase
    end
  end

endmodule