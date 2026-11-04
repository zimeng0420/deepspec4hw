module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  // State encoding: A = 2'b01, B = 2'b10
  reg [1:0] state;
  reg z_internal;

  // State definitions (one-hot)
  localparam A = 2'b01;
  localparam B = 2'b10;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= A;
    end else begin
      case (state)
        A: begin
          if (x == 0) begin
            state <= A;
          end else begin
            state <= B;
          end
        end
        B: begin
          state <= B;
        end
        default: state <= A; // Should never happen, but good practice
      endcase
    end
  end

  always @(*) begin
    case (state)
      A: begin
        if (x == 0) begin
          z_internal = 0;
        end else begin
          z_internal = 1;
        end
      end
      B: begin
        if (x == 0) begin
          z_internal = 1;
        end else begin
          z_internal = 0;
        end
      end
      default: z_internal = 0; // Default value
    endcase
  end

  assign z = z_internal;

endmodule