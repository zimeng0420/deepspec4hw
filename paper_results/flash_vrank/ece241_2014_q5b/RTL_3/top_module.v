module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  parameter A = 2'b01;
  parameter B = 2'b10;

  reg [1:0] state;
  wire z_out;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= A;
    end else begin
      case (state)
        A: begin
          if (x) begin
            state <= B;
          end else begin
            state <= A;
          end
        end
        B: begin
          state <= B;
        end
        default: state <= A; //Should never happen, but good practice.
      endcase
    end
  end

  assign z_out = (state == A && x == 1) || (state == B && x == 0);

  assign z = z_out;

endmodule