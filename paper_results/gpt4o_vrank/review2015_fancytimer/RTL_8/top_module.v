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
        IDLE = 3'b000,
        CHECK_1101 = 3'b001,
        READ_DELAY = 3'b010,
        COUNTING = 3'b011,
        DONE = 3'b100
    } state_t;
    
    reg [15:0] timer;
    reg [2:0] state, next_state;
    reg [3:0] shift_reg;
    reg [1:0] bit_cnt;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 0;
            counting <= 0;
            done <= 0;
            timer <= 0;
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
                if (data) shift_reg = {shift_reg[2:0], data}; // shift in data
                if (shift_reg == 4'b1101) begin
                    next_state = READ_DELAY;
                    bit_cnt = 0;
                end
            end

            READ_DELAY: begin
                if (bit_cnt < 4) begin
                    shift_reg = {shift_reg[2:0], data}; // shift in delay bits
                    bit_cnt = bit_cnt + 1;
                end else begin
                    timer = (shift_reg + 1) * 1000;
                    next_state = COUNTING;
                end
            end

            COUNTING: begin
                counting = 1;
                if (timer > 0) begin
                    timer = timer - 1;
                    count = timer / 1000;
                end else begin
                    counting = 0;
                    done = 1;
                    next_state = DONE;
                end
            end

            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                    done = 0;
                end
            end
        endcase
    end

endmodule