module top_module (
	input clk,
	input reset,
	input in,
	output disc,
	output flag,
	output err
);

  parameter S_IDLE = 3'b000;
  parameter S_1    = 3'b001;
  parameter S_11   = 3'b010;
  parameter S_111  = 3'b011;
  parameter S_1111 = 3'b100;
  parameter S_11111= 3'b101;
  parameter S_111111=3'b110;
  parameter S_ERROR = 3'b111;


  reg [2:0] state, next_state;
  reg disc_reg, flag_reg, err_reg;


  always @(posedge clk) begin
    if (reset) begin
      state <= S_IDLE;
      disc_reg <= 1'b0;
      flag_reg <= 1'b0;
      err_reg <= 1'b0;
    end else begin
      state <= next_state;
      disc_reg <= 1'b0;
      flag_reg <= 1'b0;
      err_reg <= 1'b0;
    end
  end

  always @(*) begin
    next_state = S_IDLE;
    disc = disc_reg;
    flag = flag_reg;
    err = err_reg;

    case (state)
      S_IDLE: begin
        if (in) begin
          next_state = S_1;
        end else begin
          next_state = S_IDLE;
        end
      end
      S_1: begin
        if (in) begin
          next_state = S_11;
        end else begin
          next_state = S_IDLE;
        end
      end
      S_11: begin
        if (in) begin
          next_state = S_111;
        end else begin
          next_state = S_IDLE;
        end
      end
      S_111: begin
        if (in) begin
          next_state = S_1111;
        end else begin
          next_state = S_IDLE;
        end
      end
      S_1111: begin
        if (in) begin
          next_state = S_11111;
        end else begin
          next_state = S_IDLE;
        end
      end
      S_11111: begin
        if (in) begin
          next_state = S_111111;
        end else begin
          disc_reg = 1'b1;
          next_state = S_IDLE;
        end
      end
      S_111111: begin
        if (in) begin
          err_reg = 1'b1;
          next_state = S_ERROR;
        end else begin
          flag_reg = 1'b1;
          next_state = S_IDLE;
        end
      end
      S_ERROR: begin
          next_state = S_ERROR;

      end
      default: begin
        next_state = S_IDLE;
      end
    endcase
  end
endmodule