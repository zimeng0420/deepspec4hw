module top_module (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

  // State definition
  localparam S_RESET = 3'b000;
  localparam S_1     = 3'b001;
  localparam S_2     = 3'b010;
  localparam S_3     = 3'b011;
  localparam S_4     = 3'b100;
  localparam S_5     = 3'b101;
  localparam S_6     = 3'b110;
  localparam S_7_PLUS= 3'b111;

  // State register
  reg [2:0] current_state;
  reg disc_r, flag_r, err_r;
  wire disc, flag, err;

  // Next state logic
  always @(posedge clk) begin
    if (reset) begin
      current_state <= S_RESET;
      disc_r <= 0;
      flag_r <= 0;
      err_r <= 0;
    end else begin
      case (current_state)
        S_RESET: begin
          if (in) current_state <= S_1;
          else current_state <= S_RESET;
          disc_r <= 0;
          flag_r <= 0;
          err_r <= 0;
        end
        S_1: begin
          if (in) current_state <= S_2;
          else current_state <= S_RESET;
          disc_r <= 0;
          flag_r <= 0;
          err_r <= 0;
        end
        S_2: begin
          if (in) current_state <= S_3;
          else current_state <= S_RESET;
          disc_r <= 0;
          flag_r <= 0;
          err_r <= 0;
        end
        S_3: begin
          if (in) current_state <= S_4;
          else current_state <= S_RESET;
          disc_r <= 0;
          flag_r <= 0;
          err_r <= 0;
        end
        S_4: begin
          if (in) current_state <= S_5;
          else current_state <= S_RESET;
          disc_r <= 0;
          flag_r <= 0;
          err_r <= 0;
        end
        S_5: begin
          if (in) current_state <= S_6;
          else current_state <= S_RESET;
          disc_r <= 0;
          flag_r <= 0;
          err_r <= 0;
        end
        S_6: begin
          if (in) current_state <= S_7_PLUS;
          else current_state <= S_RESET;
          disc_r <= 0;
          flag_r <= 0;
          err_r <= 0;
        end
        S_7_PLUS: begin
          if (in) current_state <= S_7_PLUS;
          else current_state <= S_RESET;
          disc_r <= 0;
          flag_r <= 0;
          err_r <= 0;
        end
        default: current_state <= S_RESET;
      endcase
    end
  end

  // Output logic
  assign disc = disc_r;
  assign flag = flag_r;
  assign err = err_r;

  always @(posedge clk) begin
    if (reset) begin
      disc_r <= 0;
      flag_r <= 0;
      err_r <= 0;
    end else begin
      if (current_state == S_6 && !in) begin
        flag_r <= 1;
        disc_r <= 0;
        err_r <= 0;
      end else if (current_state == S_5 && !in) begin
        disc_r <= 1;
        flag_r <= 0;
        err_r <= 0;
      end else if (current_state == S_7_PLUS) begin
        err_r <= 1;
        disc_r <= 0;
        flag_r <= 0;
      end else begin
        disc_r <= 0;
        flag_r <= 0;
        err_r <= 0;
      end
    end
  end

endmodule