module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
    );

    reg [3:0] state, next_state;
    reg [3:0] delay, delay_counter;
    reg [3:0] timer_countdown;
    reg [12:0] cycle_count; // Enough to count to 10000 cycles

    // State encoding
    localparam IDLE          = 4'd0;
    localparam SHIFT_PATTERN = 4'd1;
    localparam LOAD_DELAY    = 4'd2;
    localparam COUNTING      = 4'd3;
    localparam DONE          = 4'd4;

    // Sequential logic for state transition
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Combinational logic for next state and output
    always @(*) begin
        next_state = state;
        counting = 0;
        done = 0;

        case (state)
            IDLE: begin
                if (reset)
                    next_state = SHIFT_PATTERN;
            end
            SHIFT_PATTERN: begin
                if (shift_count == 4'd4) begin // 4 bits pattern detected
                    if (received_bits == 4'b1101)
                        next_state = LOAD_DELAY;
                    else
                        next_state = SHIFT_PATTERN;
                end
            end
            LOAD_DELAY: begin
                if (shift_count == 4'd4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                counting = 1;
                if (cycle_count == 13'd999)
                    if (timer_countdown == 4'd0)
                        next_state = DONE;
                    else
                        timer_countdown = timer_countdown - 4'd1;
            end
            DONE: begin
                done = 1;
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

    // Shift in serial data
    reg [3:0] shift_count;
    reg [3:0] received_bits;
    always @(posedge clk) begin
        if (reset || state != SHIFT_PATTERN)
            shift_count <= 4'd0;
        else if (shift_count < 4'd4)
            shift_count <= shift_count + 4'd1;

        if (state == SHIFT_PATTERN)
            received_bits[shift_count] <= data;
    end

    // Load delay value
    always @(posedge clk) begin
        if (state == LOAD_DELAY) begin
            if (shift_count < 4'd4)
                shift_count <= shift_count + 4'd1;

            if (shift_count == 4'd4)
                delay <= received_bits;
        end
    end

    // Timer countdown logic
    always @(posedge clk) begin
        if (reset || state != COUNTING) begin
            cycle_count <= 13'd0;
            delay_counter <= delay + 4'd1;
            timer_countdown <= delay;
        end else if (state == COUNTING) begin
            if (cycle_count == 13'd999) begin
                cycle_count <= 13'd0;
                delay_counter <= delay_counter - 1;
            end else begin
                cycle_count <= cycle_count + 1;
            end
        end
    end

    // Count output
    assign count = (state == COUNTING) ? timer_countdown : 4'bxxxx;

endmodule