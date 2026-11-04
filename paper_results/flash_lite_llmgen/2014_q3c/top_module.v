module top_module (
	input clk,
	input x,
	input [2:0] y,
	output reg Y0,
	output reg z
);

  // Define state encodings (for readability and maintainability)
  localparam S000 = 3'b000;
  localparam S001 = 3'b001;
  localparam S010 = 3'b010;
  localparam S011 = 3'b011;
  localparam S100 = 3'b100;

  // Internal signals for next state (Y[2:0])
  reg [2:0] Y;

  // Combinational logic for next state and output z
  always @(*) begin
    case (y)
      S000: begin
        Y = (x == 0) ? S000 : S001;
        z = 0;
      end
      S001: begin
        Y = (x == 0) ? S001 : S100;
        z = 0;
      end
      S010: begin
        Y = (x == 0) ? S010 : S001;
        z = 0;
      end
      S011: begin
        Y = (x == 0) ? S001 : S010;
        z = 1;
      end
      S100: begin
        Y = (x == 0) ? S011 : S100;
        z = 1;
      end
      default: begin // Handle any unexpected state (important for robustness)
        Y = S000; // Default to a known state
        z = 0;
      end
    endcase
  end

  // Sequential logic to update the state on the clock edge
  always @(posedge clk) begin
    // Update Y0 based on the next state Y
    Y0 <= Y[0];
  end

endmodule