module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

  // Define the states
  typedef enum logic [3:0] {
    S_IDLE   = 4'b0000, // Initial state, seen a zero recently
    S_ONE    = 4'b0001, // Seen one '1'
    S_TWO    = 4'b0010, // Seen two '1's
    S_THREE  = 4'b0011, // Seen three '1's
    S_FOUR   = 4'b0100, // Seen four '1's
    S_FIVE   = 4'b0101, // Seen five '1's
    S_SIX    = 4'b0110, // Seen six '1's
    S_SEVEN  = 4'b0111, // Seen seven '1's or more - ERROR
    S_DISC   = 4'b1000, // Output discard signal
    S_FLAG   = 4'b1001, // Output flag signal
    S_ERR    = 4'b1010  // Output error signal
  } state_t;

  reg state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= S_IDLE;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end else begin
      state <= next_state;
      disc <= 0;
      flag <= 0;
      err <= 0;

      if (state == S_DISC) disc <= 1;
      if (state == S_FLAG) flag <= 1;
      if (state == S_ERR) err <= 1;
    end
  end

  always @(*) begin
    next_state = S_IDLE; // Default next state
    case (state)
      S_IDLE: begin
        if (in == 1) next_state = S_ONE;
        else next_state = S_IDLE;
      end
      S_ONE: begin
        if (in == 1) next_state = S_TWO;
        else next_state = S_IDLE;
      end
      S_TWO: begin
        if (in == 1) next_state = S_THREE;
        else next_state = S_IDLE;
      end
      S_THREE: begin
        if (in == 1) next_state = S_FOUR;
        else next_state = S_IDLE;
      end
      S_FOUR: begin
        if (in == 1) next_state = S_FIVE;
        else next_state = S_IDLE;
      end
      S_FIVE: begin
        if (in == 1) next_state = S_SIX;
        else next_state = S_IDLE;
      end
      S_SIX: begin
        if (in == 1) next_state = S_SEVEN;
        else next_state = S_IDLE;
      end
      S_SEVEN: begin
        if (in == 1) next_state = S_SEVEN;
        else next_state = S_IDLE;
      end
      default: next_state = S_IDLE;
    endcase

      if (!reset) begin
          if (state == S_FIVE && in == 0) next_state = S_DISC;
          else if (state == S_SIX && in == 0) next_state = S_FLAG;
          else if (state == S_SEVEN) next_state = S_ERR;

      end
  end
endmodule