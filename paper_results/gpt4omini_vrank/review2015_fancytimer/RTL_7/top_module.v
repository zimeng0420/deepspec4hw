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
    reg [9:0] cycle_counter;
    reg [1:0] state;
    reg [1:0] next_state;
    
    parameter IDLE = 2'b00, DETECT = 2'b01, COUNT = 2'b10, DONE = 2'b11;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            if (state == COUNT) begin
                if (cycle_counter < (delay + 1) * 1000) begin
                    cycle_counter <= cycle_counter + 1;
                    if (cycle_counter % 1000 == 0) begin
                        if (count > 0) 
                            count <= count - 1;
                    end
                end else begin
                    counting <= 0;
                    done <= 1;
                end
            end else if (state == DETECT) begin
                // Handle counting down
                if (counting) begin
                    count <= delay;
                end
            end
        end
    end

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                counting <= 0;
                done <= 0;
                count <= 4'bxxxx;
                cycle_counter <= 0;
                if ({data, last_data} == 4'b1101) begin
                    delay <= {data, last_data}; // Shift in 4 bits for delay
                    next_state <= COUNT;
                end else begin
                    next_state <= IDLE;
                end
            end

            DETECT: begin
                if (counting) 
                    next_state <= COUNT;
                else
                    next_state <= IDLE;
            end
            
            COUNT: begin
                if (cycle_counter < (delay + 1) * 1000) 
                    next_state <= COUNT;
                else 
                    next_state <= DONE;
            end
            
            DONE: begin
                if (ack) begin
                    next_state <= IDLE;
                end
            end
        endcase
    end
endmodule