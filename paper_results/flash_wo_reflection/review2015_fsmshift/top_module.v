module top_module(
    input clk,
    input reset,
    output shift_ena
);

  reg [2:0] state;  // Use 3 bits to represent 6 states
  reg shift_ena;

  // Define state encoding
  localparam RESET_STATE = 3'b000;
  localparam CYCLE1      = 3'b001;
  localparam CYCLE2      = 3'b010;
  localparam CYCLE3      = 3'b011;
  localparam CYCLE4      = 3'b100;
  localparam IDLE        = 3'b101;

  always @(posedge clk) begin
    if (reset) begin
      state <= RESET_STATE;
      shift_ena <= 0;
    end else begin
      case (state)
        RESET_STATE: begin
          state <= CYCLE1;
          shift_ena <= 1;
        end
        CYCLE1: begin
          state <= CYCLE2;
          shift_ena <= 1;
        end
        CYCLE2: begin
          state <= CYCLE3;
          shift_ena <= 1;
        end
        CYCLE3: begin
          state <= CYCLE4;
          shift_ena <= 1;
        end
        CYCLE4: begin
          state <= IDLE;
          shift_ena <= 0;
        end
        IDLE: begin
          state <= IDLE;
          shift_ena <= 0;
        end
        default: begin
          state <= RESET_STATE;
          shift_ena <= 0;
        end
      endcase
    end
  end

  assign shift_ena = (state == CYCLE1) | (state == CYCLE2) | (state == CYCLE3) | (state == CYCLE4);

endmodule