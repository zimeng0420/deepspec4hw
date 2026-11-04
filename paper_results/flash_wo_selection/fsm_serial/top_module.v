module top_module (
    input clk,
    input in,
    input reset,
    output done
);

  // Define states
  localparam IDLE    = 4'b0000;
  localparam START   = 4'b0001;
  localparam BIT0    = 4'b0010;
  localparam BIT1    = 4'b0011;
  localparam BIT2    = 4'b0100;
  localparam BIT3    = 4'b0101;
  localparam BIT4    = 4'b0110;
  localparam BIT5    = 4'b0111;
  localparam BIT6    = 4'b1000;
  localparam BIT7    = 4'b1001;
  localparam STOP    = 4'b1010;
  localparam ERROR   = 4'b1011;

  reg [3:0] current_state;
  reg done_reg;
  wire done;

  assign done = done_reg;

  always @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      done_reg <= 0;
    end else begin
      case (current_state)
        IDLE: begin
          done_reg <= 0;
          if (in == 0) begin
            current_state <= START;
          end else begin
            current_state <= IDLE;
          end
        end
        START: begin
          current_state <= BIT0;
        end
        BIT0: begin
          current_state <= BIT1;
        end
        BIT1: begin
          current_state <= BIT2;
        end
        BIT2: begin
          current_state <= BIT3;
        end
        BIT3: begin
          current_state <= BIT4;
        end
        BIT4: begin
          current_state <= BIT5;
        end
        BIT5: begin
          current_state <= BIT6;
        end
        BIT6: begin
          current_state <= BIT7;
        end
        BIT7: begin
          current_state <= STOP;
        end
        STOP: begin
          if (in == 1) begin
            current_state <= IDLE;
            done_reg <= 1;
          end else begin
            current_state <= ERROR;
            done_reg <= 0;
          end
        end
        ERROR: begin
          done_reg <= 0;
          if (in == 1) begin
            current_state <= IDLE;
          end else begin
            current_state <= ERROR;
          end
        end
        default: begin
          current_state <= IDLE;
          done_reg <= 0;
        end
      endcase
    end
  end

endmodule