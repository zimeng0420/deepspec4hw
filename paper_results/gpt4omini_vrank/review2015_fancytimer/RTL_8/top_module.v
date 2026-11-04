module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    reg [2:0] state;
    reg [3:0] delay;
    reg [19:0] cycle_count;
    reg [9:0] countdown;
    
    parameter IDLE = 3'b000, 
              WAIT_FOR_PATTERN = 3'b001, 
              SHIFT_DELAY = 3'b010, 
              COUNTING = 3'b011, 
              WAIT_FOR_ACK = 3'b100;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            cycle_count <= 0;
            countdown <= 0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    count <= 4'b0;
                    cycle_count <= 0;
                    countdown <= 0;
                    state <= WAIT_FOR_PATTERN;
                end
                
                WAIT_FOR_PATTERN: begin
                    if (data == 1'b1) begin
                        state <= (cycle_count == 2) ? SHIFT_DELAY : WAIT_FOR_PATTERN;
                        cycle_count <= cycle_count + 1;
                    end else begin
                        cycle_count <= 0;
                    end
                end

                SHIFT_DELAY: begin
                    delay[3] <= data;
                    state <= (cycle_count < 4) ? SHIFT_DELAY : COUNTING;
                    if (cycle_count < 4) begin
                        cycle_count <= cycle_count + 1;
                    end else begin
                        countdown <= (delay + 1) * 1000;
                        count <= delay;
                        counting <= 1;
                        state <= COUNTING;
                    end
                end

                COUNTING: begin
                    if (countdown > 0) begin
                        countdown <= countdown - 1;
                        if (countdown % 1000 == 0) begin
                            count <= count - 1;
                        end
                    end else begin
                        counting <= 0;
                        done <= 1;
                        state <= WAIT_FOR_ACK;
                    end
                end

                WAIT_FOR_ACK: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end

            endcase
        end
    end

endmodule