module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

  // State machine definition
  localparam IDLE       = 4'b0000;
  localparam S1         = 4'b0001;
  localparam S2         = 4'b0010;
  localparam S3         = 4'b0011;
  localparam S4         = 4'b0100;
  localparam LOAD_DELAY = 4'b0101;
  localparam COUNTING   = 4'b0110;
  localparam DONE       = 4'b0111;

  reg [3:0] state;
  reg [3:0] next_state;

  // Data path elements
  reg [3:0] delay;
  reg [12:0] counter; //13-bit counter
  reg [9:0] cycle_counter; // Counter to 1000
  reg [3:0] count_reg;

  assign count = count_reg;

  // State machine logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
      delay <= 0;
      counter <= 0;
      cycle_counter <= 0;
      count_reg <= 0;
    end else begin
      state <= next_state;
    end
  end

  always @(*) begin
    next_state = state;
    counting = 0;
    done = 0;
    count_reg = count_reg; // Default assignment to avoid latch

    case (state)
      IDLE: begin
        if (data) next_state = S1;
        else next_state = IDLE;
      end
      S1: begin
        if (data) next_state = S2;
        else next_state = IDLE;
      end
      S2: begin
        if (!data) next_state = S3;
        else next_state = IDLE;
      end
      S3: begin
        if (data) next_state = S4;
        else next_state = IDLE;
      end
      S4: begin
        next_state = LOAD_DELAY;
      end
      LOAD_DELAY: begin
        // Shift in 4 bits for delay
        next_state = LOAD_DELAY;
      end
      COUNTING: begin
        counting = 1;
        next_state = COUNTING;
      end
      DONE: begin
        done = 1;
        if (ack) next_state = IDLE;
        else next_state = DONE;
      end
      default: next_state = IDLE;
    endcase
  end

  // Data path logic
  always @(posedge clk) begin
    if (reset) begin
      delay <= 0;
      counter <= 0;
      cycle_counter <= 0;
      count_reg <= 0;
    end else begin
      case (state)
        LOAD_DELAY: begin
          if (cycle_counter < 4) begin
            delay[3 - cycle_counter] <= data;
            cycle_counter <= cycle_counter + 1;
          end else begin
            cycle_counter <= 0;
            counter <= (delay + 1) * 1000;
            count_reg <= delay;
            next_state <= COUNTING;
          end
        end
        COUNTING: begin
          if (counter > 0) begin
            counter <= counter - 1;
            if (cycle_counter < 999) begin
              cycle_counter <= cycle_counter + 1;
            end else begin
              cycle_counter <= 0;
              if (count_reg > 0) begin
                count_reg <= count_reg - 1;
              end
            end
          end else begin
            next_state <= DONE;
          end
        end
        default: begin
          cycle_counter <= 0;
        end
      endcase
    end
  end

endmodule