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
    reg [3:0] count_reg;
    reg [3:0] state;
    
    // State encoding
    parameter IDLE = 4'b0000;
    parameter DETECT = 4'b0001;
    parameter SHIFTING = 4'b0010;
    parameter COUNTING = 4'b0011;
    parameter DONE = 4'b0100;

    // Counter and pattern detection
    reg [3:0] pattern = 4'b1101;
    reg [3:0] bit_shift;
    reg pattern_found = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count_reg <= 4'b0;
            counting <= 0;
            done <= 0;
            bit_shift <= 4'b0;
            pattern_found <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (data) begin
                        bit_shift <= {bit_shift[2:0], data};
                        if (bit_shift == pattern) begin
                            pattern_found <= 1;
                            state <= SHIFTING;
                        end
                    end
                end
                
                SHIFTING: begin
                    if (pattern_found) begin
                        delay <= {data, bit_shift[2:0]};
                        state <= COUNTING;
                        counting <= 1;
                        count_reg <= delay + 4'b1; // +1 for the counting duration
                        pattern_found <= 0;
                    end
                end
                
                COUNTING: begin
                    if (count_reg > 0) begin
                        count_reg <= count_reg - 1;
                        if (count_reg % 1000 == 0) begin
                            delay <= delay - 1;
                        end
                    end
                    else begin
                        counting <= 0;
                        done <= 1;
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    assign count = counting ? delay : 4'bxxxx; // Don't care when not counting

endmodule