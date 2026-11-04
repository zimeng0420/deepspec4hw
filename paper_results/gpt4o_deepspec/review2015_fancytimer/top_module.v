module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // FSM state definitions
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Internal registers
    reg [3:0] shift_reg;      // Shift register for pattern detection
    reg [3:0] delay_reg;      // Holds the delay[3:0]
    reg [15:0] counter;       // Countdown counter (16-bits for large values)
    reg [9:0] cycle_counter;  // 1000-cycle counter for 1000-clock gating

    wire pattern_detected;
    wire cycle_done;
    wire timer_done;

    // Outputs
    assign count = (counting) ? delay_reg : 4'bxxxx;

    // Pattern detection logic: Detect "1101" in shift_reg
    assign pattern_detected = (shift_reg == 4'b1101);
    assign cycle_done = (cycle_counter == 10'd999);  // 1000 clock cycles (0-999)
    assign timer_done = (counter == 16'd0);

    // Sequential block for FSM state transitions, shift registers and counters
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_reg <= 4'd0;
            delay_reg <= 4'd0;
            counter <= 16'd0;
            cycle_counter <= 10'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            current_state <= next_state;

            // State-dependent behavior
            case (current_state)
                IDLE: begin
                    // Shift data into shift_reg
                    shift_reg <= {shift_reg[2:0], data};
                end
                SHIFT: begin
                    // Shift in the delay value (4 bits MSB first)
                    delay_reg <= {delay_reg[2:0], data};
                end
                COUNT: begin
                    // 1000-clock cycle control
                    if (cycle_done) begin
                        cycle_counter <= 10'd0;
                        if (!timer_done) begin
                            counter <= counter - 16'd1;
                            if (counter[9:0] == 10'd0) begin
                                delay_reg <= delay_reg - 4'd1;
                            end
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 10'd1;
                    end
                end
                DONE: begin
                    // Waiting for user acknowledgment (ack)
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        // Default to current state
        next_state = current_state;
        counting = 1'b0;
        done = 1'b0;

        case (current_state)
            IDLE: begin
                if (pattern_detected) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                if (&delay_reg) begin // Fully shifted in 4 bits
                    next_state = COUNT;
                end
            end
            COUNT: begin
                counting = 1'b1;
                if (timer_done) begin
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

endmodule