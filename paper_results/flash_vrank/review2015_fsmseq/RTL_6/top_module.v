module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

  parameter S0 = 0;
  parameter S1 = 1;
  parameter S2 = 2;
  parameter S3 = 3;
  parameter S4 = 4;

  reg [2:0] state;

  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      start_shifting <= 0;
    end else begin
      case (state)
        S0: begin
          if (data == 1) begin
            state <= S1;
          end else begin
            state <= S0;
          end
        end
        S1: begin
          if (data == 1) begin
            state <= S2;
          end else begin
            state <= S0;
          end
        end
        S2: begin
          if (data == 0) begin
            state <= S3;
          end else if (data == 1) begin
              state <= S1;
          end else begin
              state <= S2;
          end
        end
        S3: begin
          if (data == 1) begin
            state <= S4;
          end else begin
            state <= S0;
          end
        end
        S4: begin
          state <= S4;
          start_shifting <= 1;
        end
        default: state <= S0;
      endcase
    end
  end

endmodule