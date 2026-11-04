module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State Encoding
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;
    reg [3:0] shift_reg;
    reg [3:0] delay_reg;
    reg [13:0] counter;
    reg [9:0] cycle_count;

    // State Transition Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            delay_reg <= 4'b0000;
            counter <= 14'd0;
            cycle_count <= 10'd0;
            count <= 4'bxxxx;
            counting <= 0;
            done <= 0;
        end else begin
            state <= next_state;

            // Update shift register and delay register
            if (state == IDLE || state == SHIFT) begin
                shift_reg <= {shift_reg[2:0], data};
            end
            
            if (state == SHIFT && shift_reg == 4'b1101) begin
                delay_reg <= {delay_reg[2:0], data};
            end

            // Counter Logic
            if (state == COUNT) begin
                if (cycle_count == 10'd999) begin
                    cycle_count <= 10'd0;
                    counter <= counter - 14'd1;
                    if (counter > 0) begin
                        count <= (counter - 1) / 1000;
                    end else begin
                        count <= 4'b0000;
                    end
                end else begin
                    cycle_count <= cycle_count + 10'd1;
                end
            end else begin
                cycle_count <= 10'd0;
            end

            // Counting control
            counting <= (state == COUNT);

            // Done signal logic
            if (state == DONE && !done) begin
                done <= 1;
            end else if (ack) begin
                done <= 0;
            end
        end
    end

    // Next State Logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                if (shift_reg == 4'b1101 && delay_reg == shift_reg) begin
                    next_state = COUNT;
                    counter = ((delay_reg + 1) * 1000);
                end
            end
            COUNT: begin
                if (counter == 0) begin
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

endmodule