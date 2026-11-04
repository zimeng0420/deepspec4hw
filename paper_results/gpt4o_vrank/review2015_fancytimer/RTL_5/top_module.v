module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State declaration
    typedef enum reg [2:0] {
        IDLE,
        PATTERN_DETECTED,
        LOAD_DELAY,
        COUNTING,
        DONE
    } state_t;
    
    state_t state, next_state;

    reg [3:0] delay;
    reg [3:0] current_count;
    reg [9:0] cycle_count;
    reg [3:0] bit_count;
    reg [3:0] shift_reg;

    assign count = (state == COUNTING) ? current_count : 4'bxxxx;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            delay <= 4'h0;
            current_count <= 4'h0;
            cycle_count <= 10'h0;
            bit_count <= 4'h0;
            shift_reg <= 4'h0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                counting = 1'b0;
                done = 1'b0;
                if (shift_reg == 4'b1101) begin
                    next_state = PATTERN_DETECTED;
                end
            end
            PATTERN_DETECTED: begin
                if (bit_count == 4'h4) begin
                    next_state = LOAD_DELAY;
                end
            end
            LOAD_DELAY: begin
                next_state = COUNTING;
            end
            COUNTING: begin
                if (cycle_count == 10'b1111101000) begin // 1000 cycles
                    if (current_count == 4'h0) begin
                        next_state = DONE;
                    end else begin
                        current_count = current_count - 1;
                        cycle_count = 10'b0;
                    end
                end
            end
            DONE: begin
                done = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Shift register and delay counter
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            bit_count <= 4'h0;
        end else if (state == IDLE) begin
            shift_reg <= {shift_reg[2:0], data};
            if (shift_reg == 4'b1101) begin
                bit_count <= 4'h0;
            end else begin
                bit_count <= bit_count + 1;
            end
        end else if (state == PATTERN_DETECTED) begin
            shift_reg <= {shift_reg[2:0], data};
            bit_count <= bit_count + 1;
            if (bit_count == 4'h3) begin
                delay <= {shift_reg[2:0], data};
            end
        end else if (state == LOAD_DELAY) begin
            current_count <= delay;
            cycle_count <= 10'b0;
        end
    end

    // Cycle counter for counting state
    always @(posedge clk) begin
        if (reset || state != COUNTING) begin
            cycle_count <= 10'h0;
        end else begin
            cycle_count <= cycle_count + 1;
        end
    end

endmodule