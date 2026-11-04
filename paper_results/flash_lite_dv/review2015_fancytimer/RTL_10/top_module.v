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
    localparam IDLE = 0;
    localparam DETECT = 1;
    localparam CAPTURE_DELAY = 2;
    localparam COUNTING = 3;
    localparam DONE_ACK = 4;

    // Internal Signals
    reg [2:0] state;
    reg [3:0] shift_reg_data;
    reg [3:0] delay;
    reg [12:0] counter;  // (delay + 1) * 1000  (max delay of 15,  so max count is 16000)
    reg [3:0] count_internal;
    reg [3:0] delay_plus_one;
    wire start_sequence_detected;
    wire [3:0] count_temp;


    // Start Sequence Detection
    always @(posedge clk) begin
        if (reset) begin
            shift_reg_data <= 4'b0;
        end else begin
            shift_reg_data <= {shift_reg_data[2:0], data};
        end
    end

    assign start_sequence_detected = (shift_reg_data == 4'b1101);


    // Delay Calculation
    always @(*) begin
      delay_plus_one = delay + 1;
    end

    // Count calculation. Use a separate combinatorial block
    assign count_temp = (counter < 1000) ? 0 : (counter/1000);


    // State Machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counting <= 1'b0;
            done <= 1'b0;
            counter <= 13'b0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (start_sequence_detected) begin
                        state <= DETECT;
                    end else begin
                        state <= IDLE;
                    end
                end
                DETECT: begin
                  state <= CAPTURE_DELAY;
                end

                CAPTURE_DELAY: begin
                    delay <= {data, data, data, data};
                    state <= COUNTING;

                end
                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    if (counter == (delay_plus_one*1000 - 1)) begin
                        state <= DONE_ACK;
                    end else begin
                        state <= COUNTING;
                    end
                end
                DONE_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack) begin
                        state <= IDLE;
                    end else begin
                        state <= DONE_ACK;
                    end
                end
                default: begin
                    state <= IDLE;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 13'b0;
        end else begin
            case (state)
                COUNTING: begin
                    counter <= counter + 1'b1;
                end
                default: begin
                    counter <= counter;
                end
            endcase
        end
    end


    always @(posedge clk or posedge reset) begin
        if(reset) begin
          count_internal <= 4'b0;
        end else begin
          if(state == COUNTING) begin
            if(counter % 1000 == 999) begin
              count_internal <= count_internal - 1'b1;
            end
            else begin
              count_internal <= count_internal;
            end
          end
        end
    end
    // Count output
    assign count = (counting) ? count_temp : 4'b0;



endmodule