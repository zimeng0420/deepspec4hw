module top_module (
	input clk,
	input reset,
	input in,
	output disc,
	output flag,
	output err
);

  // State definitions
  localparam IDLE = 3'b000;
  localparam ONE = 3'b001;
  localparam TWO = 3'b010;
  localparam THREE = 3'b011;
  localparam FOUR = 3'b100;
  localparam FIVE = 3'b101;
  localparam SIX = 3'b110;
  localparam SEVEN = 3'b111;


  // State register
  reg [2:0] state, next_state;

  // Output registers
  reg disc, flag, err;

  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;
    end else begin
      state <= next_state;
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;

      case (state)
        IDLE: begin
          if (in)
            next_state <= ONE;
          else
            next_state <= IDLE;
        end
        ONE: begin
          if (in)
            next_state <= TWO;
          else
            next_state <= IDLE;
        end
        TWO: begin
          if (in)
            next_state <= THREE;
          else
            next_state <= IDLE;
        end
        THREE: begin
          if (in)
            next_state <= FOUR;
          else
            next_state <= IDLE;
        end
        FOUR: begin
          if (in)
            next_state <= FIVE;
          else
            next_state <= IDLE;
        end
        FIVE: begin
          if (in)
            next_state <= SIX;
          else
            next_state <= IDLE;
        end
        SIX: begin
          if (in) begin
            next_state <= SEVEN;
          end else begin
            next_state <= IDLE;
            disc <= 1'b1; // Signal disc
          end
        end
        SEVEN: begin
            next_state <= SEVEN;
            err <= 1'b1; //Signal error
        end
      endcase
    end
  end

  // Output logic
  always @(posedge clk) begin
    if (reset) begin
      flag <= 1'b0;
    end else begin
      if (state == SIX && in) begin // 01111110
        flag <= 1'b1; // Signal flag
      end
    end
  end

endmodule