module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State Definitions
    localparam IDLE = 0,
               READ_DELAY = 1,
               COUNTING = 2,
               DONE_ACK = 3;

    // Internal Signals
    reg [1:0] state;
    reg [3:0] delay;
    reg [3:0] count_internal;
    reg [3:0] data_shift_reg;
    reg [3:0] delay_shift_reg;
    reg [9:0] count_cycles;
    wire start_sequence_detected;
    wire [9:0] target_count;
    
    // Start Sequence Detection
    always @(posedge clk) begin
        if (reset) begin
            data_shift_reg <= 4'b0;
        end else begin
            data_shift_reg <= {data_shift_reg[2:0], data};
        end
    end

    assign start_sequence_detected = (data_shift_reg == 4'b1101);

    // Delay Shift Register (capture delay value)
    always @(posedge clk) begin
        if (reset) begin
            delay_shift_reg <= 4'b0;
        end else if (state == READ_DELAY) begin
             delay_shift_reg <= {delay_shift_reg[2:0], data};
        end
    end
    
    // Target Count Calculation
    assign target_count = (delay + 1) * 10'd1000;  // Assuming 1000 clock cycles for delay unit
    
    // State Machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counting <= 1'b0;
            done <= 1'b0;
            count_internal <= 4'b0;
            count_cycles <= 10'd0;
            delay <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (start_sequence_detected) begin
                        state <= READ_DELAY;
                    end
                end
                READ_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                     delay <= delay_shift_reg;
                     state <= COUNTING;
                end
                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                     if (count_cycles < target_count -1 ) begin
                        count_cycles <= count_cycles + 1;
                    end
                     else if (count_cycles >= target_count-1) begin
                        count_cycles <= 10'd0;
                        state <= DONE_ACK;
                    end
                end
                DONE_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack) begin
                         state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Count Output
    always @(posedge clk or posedge reset) begin
        if (reset) begin
             count_internal <= 4'b0;
        end else begin
            if (state == COUNTING ) begin
                if (count_cycles % 1000 == 0 && count_cycles>0)
                count_internal <= count_internal -1;
            end
            else if (state == READ_DELAY)
                count_internal <= delay;
        end
    end
    assign count = (counting) ? count_internal : 4'b0 ;
    
endmodule