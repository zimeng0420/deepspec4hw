module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'd0,
        CHECK_PATTERN = 3'd1,
        LOAD_DELAY = 3'd2,
        COUNTING = 3'd3,
        DONE_WAIT_ACK = 3'd4
    } state_t;
    
    state_t state, next_state;
    reg [3:0] delay;
    reg [3:0] bits_shifted;
    reg [13:0] counter;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        counting = 0;
        done = 0;
        case(state)
            IDLE: begin
                if (data == 1) begin
                    next_state = CHECK_PATTERN;
                    bits_shifted = 4'd0;
                end
            end
            CHECK_PATTERN: begin
                if (bits_shifted == 4'd3) begin
                    if (data) begin
                        next_state = LOAD_DELAY;
                        bits_shifted = 4'd0;
                    end else begin
                        next_state = IDLE;
                    end
                end else begin
                    bits_shifted = bits_shifted + 4'd1;
                end
            end
            LOAD_DELAY: begin
                delay = (delay << 1) | data;
                if (bits_shifted == 4'd3) begin
                    next_state = COUNTING;
                    counter = (delay + 4'd1) * 1000;
                end else begin
                    bits_shifted = bits_shifted + 4'd1;
                end
            end
            COUNTING: begin
                counting = 1;
                if (counter == 0) begin
                    next_state = DONE_WAIT_ACK;
                end else begin
                    counter = counter - 1;
                    count = counter / 1000;
                end
            end
            DONE_WAIT_ACK: begin
                done = 1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule