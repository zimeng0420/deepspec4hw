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
    reg [9:0] cycle_count;
    reg [2:0] state, next_state;
    
    localparam IDLE     = 3'b000;
    localparam DETECT   = 3'b001;
    localparam SHIFT    = 3'b010;
    localparam COUNTING  = 3'b011;
    localparam DONE     = 3'b100;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            count <= 0;
            cycle_count <= 0;
        end else begin
            state <= next_state;
            if (state == COUNTING) begin
                if (cycle_count < 1000) begin
                    cycle_count <= cycle_count + 1;
                end else begin
                    cycle_count <= 0;
                    if (count > 0) begin
                        count <= count - 1;
                    end else begin
                        done <= 1;
                        counting <= 0;
                    end
                end
            end else if (state == SHIFT) begin
                count <= delay; // Initial count value set to delay
                counting <= 1;
            end else if (state == DONE && ack) begin
                next_state <= IDLE;
                done <= 0;
            end
        end
    end
    
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (data == 1) ? DETECT : IDLE;
            end
            DETECT: begin
                if (data) begin
                    next_state = DETECT;
                end else if (data == 0) begin
                    next_state = (state == IDLE) ? SHIFT : DETECT; // Pattern detection.
                end 
            end
            SHIFT: begin
                if (cycle_count < 4) begin
                    delay <= {delay[2:0], data}; // Shift in bits for delay.
                    next_state = SHIFT;
                end else begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                next_state = COUNTING;
            end
            DONE: begin
                next_state = (ack) ? IDLE : DONE;
            end
            default: next_state = IDLE;
        endcase
    end
    
endmodule