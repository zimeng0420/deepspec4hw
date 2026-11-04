module top_module (
	input clk,
	input reset,
	input in,
	output disc,
	output flag,
	output err
);

  // Define states
  localparam S_IDLE = 0;
  localparam S_ONE = 1;
  localparam S_ONE_ONE = 2;
  localparam S_ONE_ONE_ONE = 3;
  localparam S_ONE_ONE_ONE_ONE = 4;
  localparam S_ONE_ONE_ONE_ONE_ONE = 5;
  localparam S_ONE_ONE_ONE_ONE_ONE_ONE = 6;
  localparam S_ONE_ONE_ONE_ONE_ONE_ONE_ONE = 7;

  // State register
  reg [3:0] state;

  // Output registers
  reg disc_reg;
  reg flag_reg;
  reg err_reg;

  // Default output assignments
  assign disc = disc_reg;
  assign flag = flag_reg;
  assign err = err_reg;

  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      state <= S_IDLE;
      disc_reg <= 1'b0;
      flag_reg <= 1'b0;
      err_reg <= 1'b0;
    end else begin
      case (state)
        S_IDLE: begin
          if (in) begin
            state <= S_ONE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
          end else begin
            state <= S_IDLE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
          end
        end
        S_ONE: begin
          if (in) begin
            state <= S_ONE_ONE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
          end else begin
            state <= S_IDLE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
          end
        end
        S_ONE_ONE: begin
          if (in) begin
            state <= S_ONE_ONE_ONE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
          end else begin
            state <= S_IDLE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
          end
        end
        S_ONE_ONE_ONE: begin
          if (in) begin
            state <= S_ONE_ONE_ONE_ONE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
          end else begin
            state <= S_IDLE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
          end
        end
        S_ONE_ONE_ONE_ONE: begin
          if (in) begin
            state <= S_ONE_ONE_ONE_ONE_ONE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
          end else begin
            state <= S_IDLE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
          end
        end
        S_ONE_ONE_ONE_ONE_ONE: begin
          if (in) begin
            state <= S_ONE_ONE_ONE_ONE_ONE_ONE;
            disc_reg <= 1'b1; // disc
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
          end else begin
            state <= S_IDLE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
          end
        end
        S_ONE_ONE_ONE_ONE_ONE_ONE: begin
          if (in) begin
            state <= S_ONE_ONE_ONE_ONE_ONE_ONE_ONE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b1; // err
          end else begin
            state <= S_IDLE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b1; // flag
            err_reg <= 1'b0;
          end
        end
        S_ONE_ONE_ONE_ONE_ONE_ONE_ONE: begin
          state <= S_ONE_ONE_ONE_ONE_ONE_ONE_ONE; // Stay in error state
          disc_reg <= 1'b0;
          flag_reg <= 1'b0;
          err_reg <= 1'b1; // err
        end
      endcase
    end
  end
endmodule