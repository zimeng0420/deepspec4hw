module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

  // Define the states
  localparam S_IDLE = 0;
  localparam S_1    = 1;
  localparam S_2    = 2;
  localparam S_3    = 3;
  localparam S_4    = 4;
  localparam S_5    = 5;
  localparam S_6    = 6;
  localparam S_7    = 7;
  localparam S_DISC = 8;
  localparam S_FLAG = 9;
  localparam S_ERR  = 10;

  // State register
  reg [3:0] current_state;
  reg [3:0] next_state;

  // State transition logic
  always @(*) begin
    case (current_state)
      S_IDLE: begin
        if (in == 1) next_state = S_1;
        else next_state = S_IDLE;
      end
      S_1: begin
        if (in == 1) next_state = S_2;
        else next_state = S_IDLE;
      end
      S_2: begin
        if (in == 1) next_state = S_3;
        else next_state = S_IDLE;
      end
      S_3: begin
        if (in == 1) next_state = S_4;
        else next_state = S_IDLE;
      end
      S_4: begin
        if (in == 1) next_state = S_5;
        else next_state = S_IDLE;
      end
      S_5: begin
        if (in == 1) next_state = S_6;
        else next_state = S_IDLE;
      end
      S_6: begin
        if (in == 0) next_state = S_DISC;
        else next_state = S_7;
      end
      S_7: begin
        if (in == 0) next_state = S_ERR;
        else next_state = S_7;
      end
      S_DISC:  next_state = S_FLAG;
      S_FLAG:  next_state = S_ERR;
      S_ERR:   next_state = S_IDLE;
      default: next_state = S_IDLE; // Should never happen, but good practice
    endcase
  end

  // State update logic
  always @(posedge clk) begin
    if (reset) begin
      current_state <= S_IDLE;
    end else begin
      current_state <= next_state;
    end
  end

  // Output logic
  always @(posedge clk) begin
    if (reset) begin
      disc <= 0;
      flag <= 0;
      err  <= 0;
    end else begin
      disc <= (current_state == S_DISC) ? 1 : 0;
      flag <= (current_state == S_FLAG) ? 1 : 0;
      err  <= (current_state == S_ERR) ? 1 : 0;
    end
  end

endmodule