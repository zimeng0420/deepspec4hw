module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    reg [3:0] delay;
    reg [9:0] counter; 
    reg [1:0] state, next_state;
    reg [3:0] current_count;
    
    localparam IDLE = 2'b00, 
               DETECT = 2'b01, 
               COUNT = 2'b10, 
               DONE = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            current_count <= 4'b0000;
            counter <= 10'b0000000000;
        end else begin
            state <= next_state; 
        end
    end

    always @(*) begin
        next_state = state;

        case (state)
            IDLE: begin
                counting = 0;
                done = 0;

                if ({data, current_count[2:0]} == 3'b110) begin
                    next_state = DETECT;
                end
            end

            DETECT: begin
                counting = 0;

                if (counter < 10'd999) begin
                    counter = counter + 1;
                end else begin
                    delay = {current_count[2:0], data}; 
                    current_count = delay + 1;
                    counter = 0;
                    next_state = COUNT;
                end
            end

            COUNT: begin
                counting = 1;
                done = 0;

                if (current_count > 0) begin
                    if (counter < 10'd999) begin
                        counter = counter + 1;
                    end else begin
                        current_count = current_count - 1;
                        counter = 0;
                    end
                end else begin
                    done = 1;
                    counting = 0;
                    next_state = DONE;
                end
            end

            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    assign count = counting ? current_count : 4'bxxxx;

endmodule