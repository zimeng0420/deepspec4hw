module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // Define state encoding
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        DETECT_PATTERN = 3'b001,
        FETCH_DELAY = 3'b010,
        COUNTDOWN = 3'b011,
        DONE = 3'b100
    } state_t;

    state_t state, next_state;
    
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [15:0] cycle_count, delay_cycles;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 4'bxxxx;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and output logic
    always @(*) begin
        next_state = state;
        counting = 0;
        done = 0;
        case(state)
            IDLE: begin
                if (shift_reg == 4'b1101) begin
                    next_state = FETCH_DELAY;
                end
            end

            DETECT_PATTERN: begin
                if (shift_reg == 4'b1101) begin
                    next_state = FETCH_DELAY;
                end
            end

            FETCH_DELAY: begin
                if (cycle_count == 4) begin
                    delay = shift_reg;
                    delay_cycles = (shift_reg + 1) * 1000;
                    next_state = COUNTDOWN;
                end
            end

            COUNTDOWN: begin
                counting = 1;
                count = delay - (cycle_count / 1000);
                if (cycle_count == delay_cycles - 1) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                done = 1;
                if (ack) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Cycle count logic
    always @(posedge clk) begin
        if (reset || state != next_state) begin
            cycle_count <= 0;
            shift_reg <= 0;
        end else if (state == COUNTDOWN) begin
            cycle_count <= cycle_count + 1;
        end else if (state == IDLE || state == DETECT_PATTERN || state == FETCH_DELAY) begin
            shift_reg <= {shift_reg[2:0], data};
            if (state == FETCH_DELAY)
                cycle_count <= cycle_count + 1;
        end
    end

endmodule