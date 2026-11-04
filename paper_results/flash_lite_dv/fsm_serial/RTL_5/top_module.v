module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State Definitions
    parameter IDLE      = 3'b000;
    parameter START_BIT = 3'b001;
    parameter DATA_BITS = 3'b010;
    parameter STOP_BIT  = 3'b011;
    parameter ERROR     = 3'b100;

    // Internal Signals
    reg [2:0] state;
    reg [2:0] next_state;
    reg [2:0] bit_count;
    reg data_bit;
    reg stop_bit_received;

    // State Transition Logic (Combinational)
    always @(*) begin
        next_state = state;
        done = 1'b0; // Default: not done

        case (state)
            IDLE: begin
                if (in == 1'b0) // Start bit detected
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end
            START_BIT: begin
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                if (bit_count == 7)
                    next_state = STOP_BIT;
                else
                    next_state = DATA_BITS;
            end
            STOP_BIT: begin
                if (in == 1'b1) begin  // Correct stop bit
                  next_state = IDLE;
                  done = 1'b1;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in == 1'b1) begin  // Wait for stop bit
                   next_state = IDLE;
                end else
                   next_state = ERROR;

            end
            default:
                next_state = IDLE;
        endcase
    end

    // Data Bit Counter (Combinational Logic)
    always @(*) begin
      if (state == DATA_BITS) begin
         if (bit_count < 7)
            bit_count = bit_count + 1;
      end
      else
         bit_count = 0;

    end


    // State Register (Sequential)
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end


endmodule