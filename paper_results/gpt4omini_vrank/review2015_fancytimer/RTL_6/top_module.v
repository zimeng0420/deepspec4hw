module top_module(
	input wire clk,
	input wire reset,
	input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    reg [3:0] delay;
    reg [9:0] clk_count;
    reg [2:0] state; 
    reg [2:0] next_state; 
    reg [3:0] remaining_time;
    
    localparam IDLE = 3'b000,
               SEARCH = 3'b001,
               READ_DELAY = 3'b010,
               COUNT = 3'b011,
               DONE = 3'b100;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            clk_count <= 0;
            count <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = SEARCH;
            SEARCH: next_state = (data == 1'b1) ? READ_DELAY : SEARCH;
            READ_DELAY: next_state = (clk_count == 1000) ? COUNT : READ_DELAY;
            COUNT: next_state = (clk_count == (delay + 1) * 1000) ? DONE : COUNT;
            DONE: next_state = (ack) ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequence detection and delay reading
    reg [3:0] shift_reg;
    reg [2:0] pattern_count;

    always @(posedge clk) begin
        if (state == SEARCH) begin
            shift_reg <= {shift_reg[2:0], data};
            if (shift_reg == 4'b1101) begin
                pattern_count <= 0;
                clk_count <= 0;
            end
        end else if (state == READ_DELAY) begin
            if (pattern_count < 4) begin
                delay <= {delay[3:1], data};
                pattern_count <= pattern_count + 1;
            end
        end
    end

    // Counting logic
    always @(posedge clk) begin
        if (state == COUNT) begin
            counting <= 1;
            clk_count <= clk_count + 1;
            if (clk_count < 1000) begin
                remaining_time <= delay;
            end else if (clk_count < 2000) begin
                remaining_time <= delay - 1;
            end else if (clk_count < 3000) begin
                remaining_time <= delay - 2;
            end else if (clk_count < 4000) begin
                remaining_time <= delay - 3;
            end else if (clk_count < (delay + 1) * 1000) begin
                remaining_time <= delay - (clk_count / 1000);
            end else begin
                remaining_time <= 0;
                done <= 1;
                counting <= 0;
            end
        end else if (state == DONE) begin
            done <= 1;
            counting <= 0;
        end else begin
            counting <= 0;
            remaining_time <= 4'bXXXX; // Don't care
            done <= 0;
            clk_count <= 0; // Reset clk_count
        end
    end
    
    always @(posedge clk) begin
        if (state == COUNT) begin
            count <= remaining_time;
        end else begin
            count <= 4'bXXXX; // Don't care
        end
    end

endmodule