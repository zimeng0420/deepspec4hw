module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    reg [2:0] state, next_state;
    reg [3:0] delay;
    reg [3:0] remaining_count;
    reg [9:0] cycle_counter;
    
    // State encoding
    localparam IDLE = 3'd0,
               LOAD_DELAY = 3'd1,
               COUNTING = 3'd2,
               WAIT_ACK = 3'd3;

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
        next_state = state; // Default to hold state
        counting = 0;
        done = 0;
        case (state)
            IDLE: begin
                if (detect_1101(data)) begin // Helper function to detect 1101
                    next_state = LOAD_DELAY;
                end
            end
            LOAD_DELAY: begin
                if (shift_delay(data)) begin // Helper function to shift in delay value
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                counting = 1;
                if (cycle_counter == 10'd1000) begin
                    cycle_counter = 0;
                    if (remaining_count == 0) begin
                        next_state = WAIT_ACK;
                    end else begin
                        remaining_count = remaining_count - 1;
                    end
                end
            end
            WAIT_ACK: begin
                done = 1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Logic for cycle counting
    always @(posedge clk) begin
        if (state == COUNTING) begin
            cycle_counter <= cycle_counter + 1;
        end else begin
            cycle_counter <= 0;
        end
    end

    // Remaining count logic
    always @(posedge clk) begin
        if (state == LOAD_DELAY) begin
            remaining_count <= delay;
        end
    end

    // Structural assignments
    assign count = (state == COUNTING) ? remaining_count : 4'bxxxx;

    // Sequential pattern detection
    reg [3:0] shift_reg; // Shift register for pattern detection

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
        end else begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // Helper function to detect 1101 pattern
    function detect_1101(input wire bit);
        detect_1101 = (shift_reg == 4'b1101) && bit;
    endfunction

    // Shift in delay
    reg [3:0] delay_shift_reg; // Shift register for delay

    always @(posedge clk) begin
        if (state == LOAD_DELAY) begin
            delay_shift_reg <= {delay_shift_reg[2:0], data};
            if (&delay_shift_reg == 4'b1111) begin
                delay <= delay_shift_reg;
            end
        end
    end

    // Helper function to shift in delay value
    function shift_delay(input wire bit);
        shift_delay = (&delay_shift_reg == 4'b1111);
    endfunction

endmodule