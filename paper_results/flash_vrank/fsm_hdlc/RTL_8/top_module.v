module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err);

  // Define state encoding
  localparam S_IDLE  = 4'b0000;
  localparam S_1     = 4'b0001;
  localparam S_11    = 4'b0010;
  localparam S_111   = 4'b0011;
  localparam S_1111  = 4'b0100;
  localparam S_11111 = 4'b0101;
  localparam S_111110= 4'b0110;
  localparam S_111111= 4'b0111;
  localparam S_ERR   = 4'b1000;

  reg [3:0] state, next_state;

  // State transition logic
  always @(*) begin
    next_state = S_IDLE; // Default next state

    case (state)
      S_IDLE: begin
        if (in) next_state = S_1;
        else    next_state = S_IDLE;
      end
      S_1: begin
        if (in) next_state = S_11;
        else    next_state = S_IDLE;
      end
      S_11: begin
        if (in) next_state = S_111;
        else    next_state = S_IDLE;
      end
      S_111: begin
        if (in) next_state = S_1111;
        else    next_state = S_IDLE;
      end
      S_1111: begin
        if (in) next_state = S_11111;
        else    next_state = S_IDLE;
      end
      S_11111: begin
        if (in) next_state = S_111111;
        else    next_state = S_111110;
      end
      S_111110: begin
        if (in) next_state = S_1;
        else    next_state = S_IDLE;
      end
      S_111111: begin
          if(in) next_state = S_ERR;
          else next_state = S_IDLE;
      end

      S_ERR : begin
          if(in) next_state = S_ERR;
          else next_state = S_IDLE;
      end
      default: next_state = S_IDLE;
    endcase
  end

  // State register update
  always @(posedge clk) begin
    if (reset) begin
      state <= S_IDLE;
    end else begin
      state <= next_state;
    end
  end

  // Output logic
  always @(posedge clk) begin
    if (reset) begin
      disc <= 0;
      flag <= 0;
      err <= 0;
    end else begin
      disc <= 0;
      flag <= 0;
      err <= 0;
      case (state)
        S_111110: disc <= 1;
        S_111111: flag <= 1;
        S_ERR: err <= 1;
        default: begin
          disc <= 0;
          flag <= 0;
          err <= 0;
        end
      endcase
    end
  end

endmodule