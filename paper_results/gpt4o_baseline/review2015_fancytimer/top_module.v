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
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        PATTERN_DETECT = 3'b001,
        LOAD_DELAY = 3'b010,
        COUNT = 3'b011,
        FINISH = 3'b100
    } state_t;
    
    state_t state, next_state;

    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [13:0] counter;
    reg shift_enable;
    reg [3:0] remaining_time;

    assign count = (state == COUNT) ? remaining_time : 4'bx;  // When not counting, count is don't-care

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101)
                    next_state = LOAD_DELAY;
                else
                    next_state = IDLE;
            end

            LOAD_DELAY: begin
                if (counter < 4)
                    next_state = LOAD_DELAY;  // Continue shifting in 4 bits
                else
                    next_state = COUNT;  // Transition to counting
            end

            COUNT: begin
                if (counter == 0)
                    next_state = FINISH;
                else
                    next_state = COUNT;
            end

            FINISH: begin
                if (ack)
                    next_state = IDLE;  // Wait for ack to reset
                else
                    next_state = FINISH;
            end

            default: next_state = IDLE;
        endcase
    end

    // Shift register and delay loading
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            delay <= 4'b0;
            shift_enable <= 1'b1;
            counter <= 14'd0;
        end else begin
            case (state)
                IDLE: begin
                    shift_enable <= 1'b1;
                    if (shift_enable)
                        shift_reg <= {shift_reg[2:0], data};  // Shift in the data serially
                end

                LOAD_DELAY: begin
                    shift_enable <= 1'b0;  // Stop shifting
                    if (counter < 4) begin
                        delay <= {delay[2:0], data};
                        counter <= counter + 1;
                    end else begin
                        counter <= 14'd0;  // Reset counter for counting process
                    end
                end

                COUNT: begin
                    if (counter == 0 && remaining_time > 0) begin
                        remaining_time <= remaining_time - 1;
                        counter <= 14'd999;
                    end else if (counter > 0) begin
                        counter <= counter - 1;
                    end
                end

                FINISH: begin
                    // Wait for ack input
                end
            endcase
        end
    end

    // Outputs and counting control
    always @(posedge clk) begin
        if (reset) begin
            counting <= 1'b0;
            done <= 1'b0;
            remaining_time <= 4'b0;
            counter <= 14'd0;
        end else begin
            case (state)
                COUNT: begin
                    counting <= 1'b1;  // Timer is counting
                    remaining_time <= delay;  // Initialize remaining time
                end

                FINISH: begin
                    counting <= 1'b0;  // Timer is no longer counting
                    done <= 1'b1;  // Notify user
                    if (ack)
                        done <= 1'b0;  // Reset done signal once acknowledged
                end

                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end
endmodule