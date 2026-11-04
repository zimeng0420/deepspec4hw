module top_module(
    input clk,
    input reset,
    input data,
    output start_shifting
);

  // Define states
  localparam S_IDLE  = 0;
  localparam S_1     = 1;
  localparam S_11    = 2;
  localparam S_110   = 3;
  localparam S_1101  = 4;
  localparam S_FOUND = 5;

  reg [2:0] current_state;
  reg start_shifting_r;

  assign start_shifting = start_shifting_r;

  always @(posedge clk) begin
    if (reset) begin
      current_state <= S_IDLE;
      start_shifting_r <= 0;
    end else begin
      case (current_state)
        S_IDLE: begin
          if (data == 1) begin
            current_state <= S_1;
          end else begin
            current_state <= S_IDLE;
          end
        end
        S_1: begin
          if (data == 1) begin
            current_state <= S_11;
          end else begin
            current_state <= S_IDLE;
          end
        end
        S_11: begin
          if (data == 0) begin
            current_state <= S_110;
          end else begin
            current_state <= S_1;
          end
        end
        S_110: begin
          if (data == 1) begin
            current_state <= S_1101;
          end else begin
            current_state <= S_IDLE;
          end
        end
        S_1101: begin
          current_state <= S_FOUND;
          start_shifting_r <= 1;
        end
        S_FOUND: begin
          current_state <= S_FOUND;
          start_shifting_r <= 1;
        end
        default: begin
          current_state <= S_IDLE;
          start_shifting_r <= 0;
        end
      endcase
    end
  end

endmodule