module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output done
);

  reg [1:0] state; // 2 bits enough for 4 states
  reg done;

  // Define the states
  localparam SEARCH = 2'b00;
  localparam BYTE1  = 2'b01;
  localparam BYTE2  = 2'b10;
  localparam BYTE3  = 2'b11;

  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      done <= 0;
    end else begin
      case (state)
        SEARCH: begin
          done <= 0;
          if (in[3]) begin
            state <= BYTE1;
          end else begin
            state <= SEARCH;
          end
        end
        BYTE1: begin
          state <= BYTE2;
          done <= 0;
        end
        BYTE2: begin
          state <= BYTE3;
          done <= 0;
        end
        BYTE3: begin
          state <= SEARCH;
          done <= 1;
        end
        default: begin
          state <= SEARCH;
          done <= 0;
        end
      endcase
    end
  end

endmodule