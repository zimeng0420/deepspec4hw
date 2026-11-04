module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  // State declaration (one-hot encoding)
  localparam A = 2'b01;
  localparam B = 2'b10;

  reg [1:0] current_state;
  reg [1:0] next_state;
  reg z_temp;
  assign z = z_temp;


  // State register
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= A;
    end else begin
      current_state <= next_state;
    end
  end

  // Next state logic
  always @(*) begin
    case (current_state)
      A: begin
        if (x == 0) begin
          next_state = A;
		  z_temp = 0;
        end else begin
          next_state = B;
		  z_temp = 1;
        end
      end
      B: begin
        if (x == 0) begin
          next_state = B;
		  z_temp = 1;
        end else begin
          next_state = B;
		  z_temp = 0;
        end
      end
      default: begin
        next_state = A;
		z_temp = 0;
      end
    endcase
  end

endmodule