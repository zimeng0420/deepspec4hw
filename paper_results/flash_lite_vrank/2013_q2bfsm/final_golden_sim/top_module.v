module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

  // Define states
  localparam STATE_A = 3'b000;
  localparam STATE_B = 3'b001;
  localparam STATE_C = 3'b010;
  localparam STATE_D = 3'b011;
  localparam STATE_E = 3'b100;
  localparam STATE_F = 3'b101;
  localparam STATE_G = 3'b110;
  localparam STATE_H = 3'b111;

  // State register
  reg [2:0] current_state, next_state;

  // Output registers
  reg f, g;

  // Internal registers
  reg [1:0] x_history;
  reg [1:0] y_counter;

  // Sequential logic for state transitions
  always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      current_state <= STATE_A;
      f <= 0;
      g <= 0;
      x_history <= 2'b00;
      y_counter <= 2'b00;
    end else begin
      current_state <= next_state;
      // No need to reset f and g here, because they are being set to zero in all other states.
    end
  end

  // Combinational logic for next state and output calculations
  always @(*) begin
    // Default values
    next_state = current_state;
    f = 0;
    g = 0;
    y_counter = y_counter; // Keep the same

    case (current_state)
      STATE_A: begin
        if (!resetn) begin
            next_state = STATE_A; // Stay in A if reset is asserted
        end else begin
          next_state = STATE_B;
          f = 0;
          g = 0;
          x_history = 2'b00;
        end
      end
      STATE_B: begin
        next_state = STATE_C;
        f = 1;
        g = 0;
      end
      STATE_C: begin
        f = 0;
        x_history = {x_history[0], x}; // Shift x values
        if (x_history == 2'b10) begin
          next_state = STATE_D;
        end else begin
            next_state = STATE_C;
        end
        g = 0;
      end
      STATE_D: begin
        f = 0;
        x_history = {x_history[0], x};
        if(x_history == 2'b01) begin
            next_state = STATE_E;
        end
        else begin
            next_state = STATE_C;
        end
        g = 0;

      end
      STATE_E: begin
        f = 0;
        x_history = {x_history[0], x};
        if (x_history == 2'b10) begin
          next_state = STATE_F;
        end else begin
            next_state = STATE_C; // If x is not 101, go back to checking for 101.
        end
        g = 0;
      end
      STATE_F: begin
        next_state = STATE_G;
        g = 1;
        y_counter = 2'b00; // reset counter.
        f = 0;
      end
      STATE_G: begin
          f = 0;
          g = 1;
          if (y) begin
              next_state = STATE_H;
          end else if (y_counter < 2'b10) begin
              next_state = STATE_G;
              y_counter = y_counter + 1'b1;

          end else begin
              next_state = STATE_A;
              g = 0;
              y_counter = 2'b00;
          end

      end
      STATE_H: begin
        f = 0;
        g = 1;
        next_state = STATE_H;
      end
      default: begin
        next_state = STATE_A;
        f = 0;
        g = 0;
      end
    endcase
  end
endmodule