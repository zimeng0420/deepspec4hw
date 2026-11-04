module top_module (
    input clk,
    input in,
    input areset,
    output out
);

  reg state;  // State register: 0 = A, 1 = B

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 1; // Reset to state B
    end else begin
      case (state)
        0: begin // State A
          if (in == 0) begin
            state <= 1; // A --0--> B
          end else begin
            state <= 0; // A --1--> A
          end
        end
        1: begin // State B
          if (in == 0) begin
            state <= 0; // B --0--> A
          end else begin
            state <= 1; // B --1--> B
          end
        end
        default: state <= 1; // Default to state B (for safety)
      endcase
    end
  end

  assign out = state; // Output reflects the current state

endmodule