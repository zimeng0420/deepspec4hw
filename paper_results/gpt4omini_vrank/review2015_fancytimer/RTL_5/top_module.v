module top_module(
	input wire clk,
	input wire reset,
	input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    reg [3:0] delay;
    reg [9:0] bit_counter;
    reg [2:0] state;
    reg [2:0] next_state;
    reg [3:0] remaining_time;

    parameter IDLE = 3'b000, SEARCH = 3'b001, LOAD = 3'b010, COUNT = 3'b011, DONE = 3'b100;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            bit_counter <= 0;
            remaining_time <= 0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    done <= 0;
                    count <= 4'b0;
                    if (data == 1'b1 && bit_counter == 0) begin
                        bit_counter <= 1;
                    end
                end
                SEARCH: begin
                    if (bit_counter < 4) begin
                        bit_counter <= bit_counter + 1;
                    end else begin
                        delay <= {remaining_time, data}; // Shift in the bits
                        bit_counter <= 0;
                        counting <= 1;
                        next_state <= COUNT;
                    end
                end
                COUNT: begin
                    if (remaining_time > 0) begin
                        count <= remaining_time;
                        if (bit_counter < 1000) begin
                            bit_counter <= bit_counter + 1;
                        end else begin
                            remaining_time <= remaining_time - 1;
                            bit_counter <= 0;
                        end
                    end else begin
                        done <= 1;
                        counting <= 0;
                        next_state <= DONE;
                    end
                end
                DONE: begin
                    count <= 4'b0;  
                    if (ack) begin
                        next_state <= IDLE; 
                    end
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE: next_state = (data == 1'b1) ? SEARCH : IDLE;
            SEARCH: next_state = SEARCH;
            COUNT: next_state = (remaining_time > 0) ? COUNT : DONE;
            DONE: next_state = (ack) ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end
endmodule