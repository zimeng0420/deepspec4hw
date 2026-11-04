module top_module(
    input clk,
    input reset,
    input data,
    output start_shifting);

  reg start_shifting;
  reg [2:0] state;

  localparam S_IDLE = 3'b000;
  localparam S_1    = 3'b001;
  localparam S_11   = 3'b010;
  localparam S_110  = 3'b011;
  localparam S_1101 = 3'b100;
  localparam S_FOUND = 3'b101;

  always @(posedge clk) begin
    if (reset) begin
      start_shifting <= 0;
      state <= S_IDLE;
    end else begin
      case (state)
        S_IDLE: begin
          if (data == 1) begin
            state <= S_1;
          end else begin
            state <= S_IDLE;
          end
        end
        S_1: begin
          if (data == 1) begin
            state <= S_11;
          end else begin
            state <= S_IDLE;
          end
        end
        S_11: begin
          if (data == 0) begin
            state <= S_110;
          end else begin
            state <= S_11;
          end
        end
        S_110: begin
          if (data == 1) begin
            state <= S_1101;
          end else begin
            state <= S_IDLE;
          end
        end
        S_1101: begin
          start_shifting <= 1;
          state <= S_FOUND;
        end
        S_FOUND: begin
          start_shifting <= 1;
          state <= S_FOUND;
        end
        default: begin
          state <= S_IDLE;
          start_shifting <= 0;
        end
      endcase
    end
  end

  assign start_shifting = start_shifting;

endmodule