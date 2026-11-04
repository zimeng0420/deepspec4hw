module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output reg f,
	output reg g
);

  // State Definitions
  parameter A = 3'b000;
  parameter B = 3'b001;
  parameter C = 3'b010;
  parameter D = 3'b011;
  parameter E = 3'b100;
  parameter F = 3'b101;
  parameter G = 3'b110;
  parameter H = 3'b111;

  // Internal Signals
  reg [2:0] state;
  reg [1:0] x_history; // Store previous two values of x
  reg [1:0] y_counter; // Counter for y input
  reg f_delayed;

  // State Transition Logic
  always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      state <= A;
      f <= 0;
      g <= 0;
      x_history <= 2'b00;
      y_counter <= 2'b00;
      f_delayed <= 0;
    end else begin
      case (state)
        A: begin
          f <= 0;
          g <= 0;
          x_history <= 2'b00;
          y_counter <= 2'b00;
          f_delayed <= 0;
          if (f_delayed == 0) begin
            f_delayed <= 1;
            state <= B;
          end else begin
            state <= A;
          end
        end
        B: begin
          f <= 1;
          g <= 0;
          x_history <= {x_history[0], x};
          y_counter <= 2'b00;
          if (x_history == 2'b10 && x == 1) begin
            state <= C;
          end else begin
            state <= B;
          end
        end
        C: begin
          f <= 0;
          g <= 1;
          y_counter <= 2'b00;
          if (y == 1) begin
            state <= G;
          end else begin
            state <= D;
          end
        end
        D: begin
          f <= 0;
          g <= 1;
          if (y == 1) begin
            state <= G;
          end else begin
            y_counter <= y_counter + 1;
            if (y_counter == 2'b10) begin
              state <= E;
            end else begin
              state <= D;
            end
          end
        end
        E: begin
          f <= 0;
          g <= 0;
          state <= E;
        end
        G: begin
          f <= 0;
          g <= 1;
          state <= G;
        end
        default: begin
          state <= A;
          f <= 0;
          g <= 0;
          x_history <= 2'b00;
          y_counter <= 2'b00;
          f_delayed <= 0;
        end
      endcase
    end
  end

endmodule