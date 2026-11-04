module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting);

  reg [2:0] state;

  // Define state encoding
  localparam S0 = 3'b000; // Initial state
  localparam S1 = 3'b001; // First 1 found
  localparam S2 = 3'b010; // 11 found
  localparam S3 = 3'b011; // 110 found
  localparam S4 = 3'b100; // 1101 found

  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      start_shifting <= 0;
    end else begin
      case (state)
        S0: begin
          if (data) begin
            state <= S1;
          end else begin
            state <= S0;
          end
        end
        S1: begin
          if (data) begin
            state <= S2;
          end else begin
            state <= S0;
          end
        end
        S2: begin
          if (data) begin
            state <= S1;
          end else begin
            state <= S3;
          end
        end
        S3: begin
          if (data) begin
            state <= S4;
          end else begin
            state <= S0;
          end
        end
        S4: begin
          state <= S4;
          start_shifting <= 1;
        end
        default: begin
          state <= S0;
          start_shifting <= 0;
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      start_shifting <= 0;
    end else if (state == S4) begin
      start_shifting <= 1;
    end
  end

endmodule