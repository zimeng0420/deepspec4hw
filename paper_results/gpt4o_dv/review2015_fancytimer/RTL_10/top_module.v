module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    // State encoding
    typedef enum reg [1:0] {IDLE, SHIFT, COUNT, DONE} state_type;
    state_type state, next_state;

    // Internal registers
    reg [3:0] shift_reg;
    reg [3:0] delay_reg;
    reg [15:0] counter;
    reg [9:0] cycle_count;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and outputs
    always @(*) begin
        // Default outputs
        counting = 1'b0;
        done = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                if (cycle_count == 4) begin
                    next_state = COUNT;
                end
            end

            COUNT: begin
                counting = 1'b1;
                if (counter == 0) begin
                    next_state = DONE;
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

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            delay_reg <= 4'b0;
            counter <= 16'b0;
            cycle_count <= 10'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                end

                SHIFT: begin
                    cycle_count <= cycle_count + 1;
                    if (cycle_count < 4) begin
                        delay_reg <= {delay_reg[2:0], data};
                    end
                end

                COUNT: begin
                    if (counter > 0) begin
                        counter <= counter - 1;
                        cycle_count <= cycle_count + 1;
                        if (cycle_count >= 1000) begin
                            cycle_count <= 0;
                            count <= count - 1;
                        end
                    end
                end

                DONE: begin
                    // Wait for ack
                end
            endcase

            // Initialize counter when entering the COUNT state
            if (state == SHIFT && next_state == COUNT) begin
                counter <= (delay_reg + 1) * 1000 - 1;
                count <= delay_reg;
            end
        end
    end

endmodule