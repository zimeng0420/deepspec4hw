module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output done
);

  reg [1:0] current_state;
  reg done;

  // Define state encoding
  localparam SEARCHING = 2'b00;
  localparam BYTE1     = 2'b01;
  localparam BYTE2     = 2'b10;
  localparam BYTE3     = 2'b11;

  always @(posedge clk) begin
    if (reset) begin
      current_state <= SEARCHING;
      done <= 0;
    end else begin
      case (current_state)
        SEARCHING: begin
          if (in[3]) begin
            current_state <= BYTE1;
            done <= 0;
          end else begin
            current_state <= SEARCHING;
            done <= 0;
          end
        end
        BYTE1: begin
          current_state <= BYTE2;
          done <= 0;
        end
        BYTE2: begin
          current_state <= BYTE3;
          done <= 0;
        end
        BYTE3: begin
          current_state <= SEARCHING;
          done <= 1;
        end
        default: begin
          current_state <= SEARCHING;
          done <= 0;
        end
      endcase
    end
  end

  assign done = (current_state == BYTE3);

endmodule