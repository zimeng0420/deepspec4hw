module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State Definitions
    parameter IDLE = 3'b000;        // Waiting for start sequence
    parameter CAPTURE_DELAY = 3'b001; // Capturing the delay value
    parameter COUNTING = 3'b010;      // Counting down
    parameter DONE = 3'b011;          // Timer done, waiting for ack

    // Internal Signals
    reg [2:0] state;
    reg [3:0] delay;
    reg [3:0] count_internal;
    reg [3:0] data_shift_reg;       // Shift register for data input
    reg [11:0] counter;            // 1000 clock cycle counter
    reg [3:0] delay_internal;      // Internal register for delay


    // State Machine Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            counter <= 12'd0;
            data_shift_reg <= 4'b0;
            delay <= 4'b0;
            count_internal <= 4'b0;

        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    data_shift_reg <= {data, data_shift_reg[3:1]}; // Shift in data
                    if (data_shift_reg == 4'b1101) begin
                        state <= CAPTURE_DELAY;
                    end
                end
                CAPTURE_DELAY: begin
                    data_shift_reg <= {data, data_shift_reg[3:1]}; // Shift in data
                    delay <= data_shift_reg[3:0];
                    delay_internal <= delay;
                    state <= COUNTING;
                end
                COUNTING: begin
                    counting <= 1;
                    done <= 0;
                    count <= delay_internal;

                    if (counter == 12'd999) begin
                        counter <= 12'd0;
                        if (delay_internal > 0) begin
                            delay_internal <= delay_internal - 1'b1;
                        end else begin
                            state <= DONE;
                        end
                    end else begin
                        counter <= counter + 1'b1;
                    end
                end
                DONE: begin
                    counting <= 0;
                    done <= 1;
                    count <= 4'b0; // Or some other don't-care value
                    if (ack) begin
                        state <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE;
                    counting <= 0;
                    done <= 0;
                    count <= 4'b0;
                    counter <= 12'd0;
                    data_shift_reg <= 4'b0;
                    delay <= 4'b0;
                    count_internal <= 4'b0;
                end
            endcase
        end
    end

endmodule