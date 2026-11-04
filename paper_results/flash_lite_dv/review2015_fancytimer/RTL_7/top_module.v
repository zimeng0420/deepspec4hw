module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State Definitions
    localparam IDLE = 3'b000;
    localparam READ_DELAY = 3'b001;
    localparam COUNTING = 3'b010;
    localparam DONE_WAIT_ACK = 3'b011;

    // Internal Signals
    reg [2:0] state;
    reg [3:0] delay;
    reg [12:0] timer_count; // (delay + 1) * 1000. Max value is 15*1000 = 15000
    reg [3:0] data_shift_reg;
    reg [3:0] count_internal;
    reg [9:0] clock_counter;
    reg start_sequence_detected;


    // Start Sequence Detection
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_shift_reg <= 4'b0000;
            start_sequence_detected <= 1'b0;
        end else begin
            data_shift_reg <= {data_shift_reg[2:0], data};
            if (data_shift_reg == 4'b1101)
              start_sequence_detected <= 1'b1;
            else
                start_sequence_detected <= 1'b0;

        end
    end

    // State Machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counting <= 1'b0;
            done <= 1'b0;
            count_internal <= 4'b0;

        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (start_sequence_detected) {
                        state <= READ_DELAY;
                    } else {
                        state <= IDLE;
                    }

                end
                READ_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    state <= COUNTING;
                end
                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    if (timer_count == 0) {
                        state <= DONE_WAIT_ACK;
                    } else {
                        state <= COUNTING;
                    }
                end
                DONE_WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack) {
                        state <= IDLE;
                    } else {
                        state <= DONE_WAIT_ACK;
                    }
                end
                default: state <= IDLE;
            endcase
        end
    end


    // Delay Value Capture
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            delay <= 4'b0;
        end else begin
            if (state == READ_DELAY) begin
                delay[0] <= data;
            end else if(state == COUNTING) begin
              // keep delay
            end
            else begin
              delay <= delay;
            end
        end
    end

    // Timer Count Calculation, decrements every 1000 cycles
    always @(posedge clk or posedge reset) begin
        if (reset) begin
          timer_count <= 13'd0;
          clock_counter <= 10'd0;
        end else begin
            if (state == COUNTING) begin
                if (clock_counter == 999) {
                    if (timer_count > 0)
                      timer_count <= timer_count - 1;
                    clock_counter <= 10'd0;
                } else {
                    clock_counter <= clock_counter + 1'b1;
                }

            end
            else if (state == READ_DELAY) {
                timer_count <= (delay + 1'b1) * 1000;
                clock_counter <= 10'd0;
            }
        end
    end


    // Count Output
    always @(*) begin
        if (state == COUNTING) begin
            count_internal = timer_count[12:9];
        end else if (state == DONE_WAIT_ACK) {
            count_internal = 4'b0;
        }
        else
            count_internal = 4'b0;
    end


    // Count Output
    assign count = count_internal;


endmodule