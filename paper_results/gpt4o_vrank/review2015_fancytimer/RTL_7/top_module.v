module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE        = 3'b000,
        DETECT_1101 = 3'b001,
        LOAD_DELAY  = 3'b010,
        COUNT       = 3'b011,
        DONE        = 3'b100
    } state_t;

    state_t state, next_state;
    reg [3:0] delay;
    reg [9:0] cycle_count;  // 10-bit count for up to 1000 cycles
    reg [3:0] delay_latch;
    reg [3:0] bit_shift_count;
    reg [3:0] pattern;      // to detect 1101 

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            pattern <= 4'b0000;
            delay <= 4'b0000;
            delay_latch <= 4'b0000;
            cycle_count <= 10'd0;
            bit_shift_count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end
        else if (state == DETECT_1101 || state == LOAD_DELAY) begin
            pattern <= {pattern[2:0], data}; // Shift data in for pattern detection
        end
        if (state == LOAD_DELAY && bit_shift_count < 4) begin
            delay <= {delay[2:0], data}; // Shift in 4-bit delay value
            bit_shift_count <= bit_shift_count + 1;
        end
        if (state == COUNT) begin
            if (cycle_count == 10'd999) begin
                delay_latch <= delay_latch - 1;
                cycle_count <= 10'd0;
            end
            else begin
                cycle_count <= cycle_count + 1;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                counting = 1'b0;
                done = 1'b0;
                if (pattern == 4'b1101) begin
                    next_state = LOAD_DELAY;
                end
                else begin
                    next_state = IDLE;
                end
            end

            DETECT_1101: begin
                next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (bit_shift_count == 4) begin
                    delay_latch = delay;
                    next_state = COUNT;
                end
                else begin
                    next_state = LOAD_DELAY;
                end
            end

            COUNT: begin
                counting = 1'b1;
                if (delay_latch == 4'b0000 && cycle_count == 10'd999) begin
                    next_state = DONE;
                end
                else begin
                    next_state = COUNT;
                end
            end

            DONE: begin
                counting = 1'b0;
                done = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = DONE;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    assign count = (state == COUNT) ? delay_latch : 4'bxxxx;

endmodule