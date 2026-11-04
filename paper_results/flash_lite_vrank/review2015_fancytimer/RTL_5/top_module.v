module top_module(
	input wire clk,
	input wire reset,
	input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    // Internal state variables
    parameter IDLE = 0,
              READ_SEQ = 1,
              READ_DELAY = 2,
              COUNTING = 3,
              WAIT_ACK = 4;

    reg [2:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [15:0] counter;
    reg [3:0] remaining_time;
    reg [1:0] seq_reg; // Shift register to detect the 1101 sequence


    // State Machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            counter <= 0;
            remaining_time <= 0;
            seq_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    counter <= 0;
                    seq_reg <= {seq_reg[0], data};
                    if (seq_reg == 2'b11 && data == 1'b0) begin
                        state <= READ_SEQ;
                    end
                end
                READ_SEQ: begin
                  seq_reg <= {seq_reg[0], data};
                  if(seq_reg == 2'b10) begin // Check for 1101 sequence
                      state <= READ_DELAY;
                  end
                end

                READ_DELAY: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg[3:0] != 4'b0000) begin // Check if reading delay value is not 0, this will handle the case when the counter has not started yet
                        delay <= shift_reg[3:0];
                    end
                    state <= COUNTING;
                    counter <= 0;
                    remaining_time <= delay;
                    counting <= 1;
                end

                COUNTING: begin
                    counting <= 1;
                    if (counter == 999) begin // Count up to 1000
                        counter <= 0;
                        remaining_time <= remaining_time - 1'b1;
                        if (remaining_time == 0) begin
                            state <= WAIT_ACK;
                            counting <= 0;
                            done <= 1;
                        end
                    end else begin
                        counter <= counter + 1;
                    end
                end

                WAIT_ACK: begin
                    counting <= 0;
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase
        end
    end

    // Output assignments
    assign count = remaining_time;


endmodule