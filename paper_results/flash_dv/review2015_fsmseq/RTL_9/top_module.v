module top_module(
    input clk,
    input reset,
    input data,
    output start_shifting
);

  // Define states
  localparam S_IDLE  = 3'b000;
  localparam S_1     = 3'b001;
  localparam S_11    = 3'b010;
  localparam S_110   = 3'b011;
  localparam S_1101  = 3'b100;
  localparam S_FOUND = 3'b101;

  // State register
  reg [2:0] current_state;
  reg start_shifting_r;

  // Output register
  assign start_shifting = start_shifting_r;

  // State transition logic
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
          // Stay in found state until reset
          start_shifting_r <= 1;
          current_state <= S_FOUND;
        end
        default: begin
          current_state <= S_IDLE;
          start_shifting_r <= 0;
        end
      endcase
    end
  end

endmodule