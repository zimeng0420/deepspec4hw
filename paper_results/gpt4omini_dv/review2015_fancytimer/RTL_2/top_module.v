module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    reg [3:0] delay;
    reg [15:0] counter;
    reg [2:0] state;
    reg [2:0] next_state;

    localparam WAIT = 3'b000, DETECT = 3'b001, LOAD_DELAY = 3'b010, COUNTING = 3'b011, DONE = 3'b100;

    // Pattern detection
    reg [3:0] pattern_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0000;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT;
            counting <= 0;
            done <= 0;
            count <= 4'b0000;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            WAIT: begin
                counting = 0;
                done = 0;
                count = 4'bxxxx; // Don't care when not counting
                if (pattern_reg == 4'b1101) 
                    next_state = LOAD_DELAY;
            end
            
            LOAD_DELAY: begin
                if (counter < 999) begin
                    next_state = LOAD_DELAY; // Waiting for next 4 bits
                    if (counter == 999) 
                        delay = {data, delay[3:1]}; // Shift in new delay bits
                end
                if (counter >= 999) begin
                    next_state = COUNTING;
                    counter = 0;
                end
            end
            
            COUNTING: begin
                counting = 1;
                if (counter >= (delay + 1) * 1000 - 1) begin
                    next_state = DONE;
                    counter = 0;
                end
            end
            
            DONE: begin
                counting = 0;
                done = 1;
                if (ack)
                    next_state = WAIT; // Acknowledge received, go back to WAIT
            end
            
            default: next_state = WAIT;
        endcase
    end

    always @(posedge clk) begin
        if (state == COUNTING) begin
            if (counter < 999) begin
                counter <= counter + 1;
            end else begin
                count <= delay; // Output current delay
                if (delay > 0)
                    delay <= delay - 1; // Decrement delay for the next cycle
            end
        end else if (state == LOAD_DELAY) begin
            if (counter < 999) begin
                counter <= counter + 1;
                count <= delay; // Maintain output during load
            end
        end else begin
            counter <= 0; // Reset counter when not counting
        end
    end

endmodule