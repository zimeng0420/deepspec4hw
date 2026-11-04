module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State definitions
    parameter IDLE = 0;
    parameter DETECT = 1;
    parameter CAPTURE = 2;
    parameter COUNTING = 3;
    parameter DONE = 4;

    // Internal signals
    reg [2:0] state;
    reg [3:0] delay;
    reg [3:0] count_internal; // Internal counter for display
    reg [3:0] shift_reg;
    reg [3:0] delay_capture_shift_reg;
    reg [31:0] timer_counter;
    wire start_detected;
    wire timer_done;
    wire [3:0] remaining_time;
    
    // Start sequence detection
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
        end else begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    assign start_detected = (shift_reg == 4'b1101);

    // Delay capture
    always @(posedge clk) begin
      if (reset) begin
        delay_capture_shift_reg <= 4'b0000;
      end else if (start_detected && state == DETECT) begin
            delay_capture_shift_reg <= {delay_capture_shift_reg[2:0], data};
        end
    end

    // Count calculation and timer
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            timer_counter <= 0;
        end else if (counting) begin
          if (timer_counter < ((delay + 1) * 1000) -1)
            timer_counter <= timer_counter + 1;
          else
            timer_counter <= 0;
        end
    end

    assign timer_done = (timer_counter == ((delay + 1) * 1000) - 1) && counting;

    // Count output
    always @(*) begin
        if (!counting) begin
            count_internal = 4'b0000; // Don't care
        end else begin
            count_internal = (delay + 1) - (timer_counter / 1000); // remaining_time;
            if (count_internal < 0)
                count_internal = 0;
        end
    end

    assign remaining_time = count_internal;


    // State machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counting <= 1'b0;
            done <= 1'b0;
            delay <= 4'b0;
            timer_counter <= 0;

        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (start_detected) begin
                        state <= DETECT;
                    end
                end
                DETECT: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    state <= CAPTURE;
                end
                CAPTURE: begin
                    delay <= delay_capture_shift_reg;
                    counting <= 1'b1;
                    done <= 1'b0;
                    state <= COUNTING;
                end
                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (timer_done)
                    begin
                      state <= DONE;
                    end

                end
                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
    
    assign count = remaining_time;

endmodule