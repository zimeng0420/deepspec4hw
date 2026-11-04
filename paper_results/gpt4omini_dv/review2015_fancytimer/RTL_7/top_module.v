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
    reg [10:0] counter;
    reg [2:0] state;
    
    localparam IDLE = 3'b000, 
               DETECT = 3'b001, 
               SHIFT = 3'b010, 
               COUNT = 3'b011, 
               DONE = 3'b100;

    wire [3:0] current_count;

    assign current_count = delay > counter / 1000 ? delay : (delay - 1);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            count <= 4'b0000;
            counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    if (data) begin
                        state <= DETECT;
                    end
                end
                DETECT: begin
                    if ({data, shift_reg} == 4'b1101) begin
                        state <= SHIFT;
                        shift_reg <= 0; // Reset shift register
                    end
                end
                SHIFT: begin
                    shift_reg <= {shift_reg[2:0], data}; // Shift in new data
                    if (counter < 3) begin
                        counter <= counter + 1;
                    end else begin
                        delay <= {shift_reg, data}; // Capture delay
                        counter <= 0;
                        state <= COUNT;
                        counting <= 1;
                    end
                end
                COUNT: begin
                    count <= current_count;
                    if (counter < (delay + 1) * 1000 - 1) begin
                        counter <= counter + 1;
                    end else begin
                        counting <= 0;
                        done <= 1;
                        state <= DONE;
                    end
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE; // Reset to IDLE on ack
                        done <= 0;
                        count <= 4'b0000;
                    end
                end
            endcase
        end
    end
    
endmodule