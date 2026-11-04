module top_module (
    input clk,
    input in,
    input reset,
    output done
);

  parameter IDLE     = 4'b0001;
  parameter START    = 4'b0010;
  parameter DATA0    = 4'b0011;
  parameter DATA1    = 4'b0100;
  parameter DATA2    = 4'b0101;
  parameter DATA3    = 4'b0110;
  parameter DATA4    = 4'b0111;
  parameter DATA5    = 4'b1000;
  parameter DATA6    = 4'b1001;
  parameter DATA7    = 4'b1010;
  parameter STOP     = 4'b1011;
  parameter WAIT_STOP = 4'b1100;

  reg [3:0] current_state;
  reg [3:0] next_state;
  reg done_r;
  wire done;

  assign done = done_r;

  always @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      done_r <= 0;
    end else begin
      current_state <= next_state;
      done_r <= (current_state == STOP && in == 1'b1) ? 1'b1 : 1'b0;
    end
  end

  always @(*) begin
    case (current_state)
      IDLE: begin
        if (in == 1'b0) begin
          next_state = START;
        end else begin
          next_state = IDLE;
        end
      end
      START: begin
        next_state = DATA0;
      end
      DATA0: begin
        next_state = DATA1;
      end
      DATA1: begin
        next_state = DATA2;
      end
      DATA2: begin
        next_state = DATA3;
      end
      DATA3: begin
        next_state = DATA4;
      end
      DATA4: begin
        next_state = DATA5;
      end
      DATA5: begin
        next_state = DATA6;
      end
      DATA6: begin
        next_state = DATA7;
      end
      DATA7: begin
        next_state = STOP;
      end
      STOP: begin
        if (in == 1'b1) begin
          next_state = IDLE;
        end else begin
          next_state = WAIT_STOP;
        end
      end
      WAIT_STOP: begin
        if (in == 1'b1) begin
          next_state = IDLE;
        end else begin
          next_state = WAIT_STOP;
        end
      end
      default: next_state = IDLE;
    end
  end

endmodule