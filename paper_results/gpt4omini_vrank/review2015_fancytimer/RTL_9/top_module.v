module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    reg [3:0] delay;
    reg [3:0] current_time;
    reg [3:0] state;
    reg [10:0] cycle_counter;
    reg [3:0] search_pattern [0:3];
    reg [3:0] bit_counter;
    
    localparam IDLE = 4'b0000;
    localparam WAIT_PATTERN = 4'b0001;
    localparam SHIFT_DELAY = 4'b0010;
    localparam COUNTING = 4'b0011;
    localparam DONE = 4'b0100;

    initial begin
        search_pattern[0] = 4'b1101;
        search_pattern[1] = 4'b0000;
        search_pattern[2] = 4'b0000;
        search_pattern[3] = 4'b0000;
    end
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 4'bxxxx;
            counting <= 0;
            done <= 0;
            cycle_counter <= 0;
            current_time <= 0;
            bit_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data) begin
                        state <= WAIT_PATTERN;
                    end
                end
                
                WAIT_PATTERN: begin
                    if (bit_counter < 4) begin
                        if (data == search_pattern[bit_counter][3]) begin
                            bit_counter <= bit_counter + 1;
                        end else begin
                            bit_counter <= 0;
                        end
                    end else if (bit_counter == 4) begin
                        state <= SHIFT_DELAY;
                        bit_counter <= 0;
                    end
                end
                
                SHIFT_DELAY: begin
                    delay[3] <= data;
                    state <= COUNTING;
                    delay[2:0] <= {data, delay[2:1]};
                    current_time <= delay;
                    counting <= 1;
                    cycle_counter <= 0;
                end
                
                COUNTING: begin
                    if (cycle_counter < (delay + 1) * 1000) begin
                        if (cycle_counter % 1000 == 0) begin
                            count <= current_time;
                        end
                        cycle_counter <= cycle_counter + 1;
                        if (cycle_counter % 1000 == 999) begin
                            if (current_time > 0) 
                                current_time <= current_time - 1;
                        end
                    end else begin
                        counting <= 0;
                        done <= 1;
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        done <= 0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule