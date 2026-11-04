module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );
    
    reg [3:0] delay;
    reg [9:0] cycle_count;
    reg [2:0] state, next_state;
    
    parameter IDLE = 3'b000, SEARCH = 3'b001, READ_DELAY = 3'b010, COUNT = 3'b011, DONE = 3'b100;
    parameter PATTERN = 4'b1101;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            count <= 4'bxxxx;
            done <= 0;
            cycle_count <= 0;
        end
        else begin
            state <= next_state;
            if (state == COUNT) begin
                if (cycle_count < (delay + 1) * 1000) begin
                    cycle_count <= cycle_count + 1;
                    count <= delay; // output current remaining time
                    if (cycle_count % 1000 == 0) begin
                        if (delay > 0) delay <= delay - 1;
                    end
                end
                else begin
                    counting <= 0;
                    done <= 1;
                    count <= 4'bxxxx; // don't care when done
                end
            end
            else if (state == DONE && ack) begin
                done <= 0;
                count <= 4'bxxxx; // reset count output on ack
                cycle_count <= 0;
            end
        end
    end

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                counting <= 0;
                if (data == PATTERN[3]) begin
                    next_state <= SEARCH;
                end
                else begin
                    next_state <= IDLE;
                end
            end
            
            SEARCH: begin
                if (data == PATTERN[2]) begin
                    next_state <= SEARCH;
                end
                else if (data == PATTERN[1]) begin
                    next_state <= SEARCH;
                end
                else if (data == PATTERN[0]) begin
                    next_state <= READ_DELAY;
                end
                else next_state <= IDLE;
            end
            
            READ_DELAY: begin
                delay <= {data, delay[3:1]}; // shift in new delay bit
                if (cycle_count < 4) begin // need to read 4 bits
                    next_state <= READ_DELAY;
                end
                else begin
                    counting <= 1;
                    cycle_count <= 0;
                    next_state <= COUNT;
                end
            end
            
            COUNT: begin
                next_state <= COUNT;
            end
            
            DONE: begin
                next_state <= DONE; 
            end
            
            default: next_state <= IDLE;
        endcase
    end
    
endmodule