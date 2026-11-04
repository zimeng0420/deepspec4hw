module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    reg [3:0] delay;
    reg [3:0] counter;
    reg [3:0] current_count;
    reg [2:0] state;
    reg [2:0] next_state;

    localparam IDLE         = 3'b000;
    localparam WAIT_PATTERN = 3'b001;
    localparam SHIFT_DELAY  = 3'b010;
    localparam COUNTING     = 3'b011;
    localparam DONE         = 3'b100;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            current_count <= 0;
        end else begin
            state <= next_state;

            if (state == COUNTING) begin
                if (counter > 0) begin
                    counter <= counter - 1;
                    current_count <= counter[3:0] / 1000; // Output remaining time
                end else begin
                    done <= 1;
                    counting <= 0;
                    current_count <= 0;
                end
            end else if (state == DONE) begin
                if (ack) begin
                    done <= 0;
                    state <= IDLE; // Restart searching
                end
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                counting = 0;
                done = 0;
                if (data == 1) begin
                    next_state = WAIT_PATTERN;
                end
            end
            
            WAIT_PATTERN: begin
                if (data == 1) begin
                    next_state = WAIT_PATTERN;
                end else if (data == 0) begin
                    next_state = SHIFT_DELAY;
                end
            end
            
            SHIFT_DELAY: begin
                delay = {data, delay[3:1]}; // Shift in next bit
                if (delay[3:0] == 4'b1111) begin
                    counter = (delay + 1) * 1000; // Compute countdown
                    counting = 1;
                    next_state = COUNTING;
                end
            end
            
            COUNTING: begin
                counting = 1;
                if (!done) begin
                    counter = counter - 1;
                    current_count = counter[3:0]; // Output current count
                    if (counter == 0) begin
                        next_state = DONE;
                    end
                end
            end
            
            DONE: begin
                counting = 0;
                done = 1;
                if (ack) begin
                    next_state = IDLE; // Wait for acknowledgment
                end
            end
        endcase
    end

    assign count = (state == COUNTING) ? current_count : 4'bzzzz; // Don't care when not counting.

endmodule