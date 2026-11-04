module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // Internal signals
    reg [3:0] shift_reg; // Shift register for start sequence detection and delay input
    reg [3:0] delay;      // Delay value
    reg [31:0] counter;   // Counter for the timer (counts up to (delay + 1) * 1000)
    reg [3:0] count_out;  // Output count (remaining time)
    reg [11:0] count_1000; // Counter to count 1000 clock cycles
    
    // State machine states
    parameter IDLE = 0,
              DETECT = 1,
              CAPTURE = 2,
              COUNTING = 3,
              DONE = 4;

    reg [2:0] state;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counting <= 1'b0;
            done <= 1'b0;
            shift_reg <= 4'b0;
            delay <= 4'b0;
            counter <= 32'd0;
            count_out <= 4'b0;
            count_1000 <= 12'd0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count_1000 <= 12'd0;
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= DETECT;
                    end
                end
                DETECT: begin
                    shift_reg <= {shift_reg[2:0], data};
                    state <= CAPTURE;

                end
                CAPTURE: begin
                    delay <= shift_reg[3:0];
                    counter <= 32'd0;
                    count_out <= delay;
                    state <= COUNTING;
                end
                COUNTING: begin
                    counting <= 1'b1;
                    if(count_1000 < 1000 -1)
                    begin
                        count_1000 <= count_1000 + 1;
                    end
                    else
                    begin
                        count_1000 <= 0;

                        if(count_out > 0)
                            count_out <= count_out - 1;
                    end
                        
                    counter <= counter + 1;
                    if (counter == ((delay + 1) * 1000) ) begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

    // Output assignments
    always @(*) begin
        if (state == COUNTING) begin
            count = count_out;
        end else begin
            count = 4'b0; // Or don't care - but initializing to 0 is useful.
        end
    end
endmodule