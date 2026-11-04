module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
    );

    // State encoding
    localparam IDLE = 2'd0;
    localparam SHIFT = 2'd1;
    localparam COUNT = 2'd2;
    localparam DONE = 2'd3;

    reg [1:0] state, next_state;
    reg [3:0] shift_reg;
    reg [3:0] delay_reg;
    reg [13:0] counter; // To count up to (15+1)*1000=16000 with ample space

    // FSM State Transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // FSM Next State Logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                if (counter == 4) // After capturing 4 bits
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                if (counter == 0)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                if (ack) 
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential Logic
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            delay_reg <= 4'b0;
            counter <= 14'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'bxxxx;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in bits to detect "1101"
                    shift_reg <= {shift_reg[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                end
                SHIFT: begin
                    // Shift in the delay bits
                    if (counter < 4) begin
                        delay_reg <= {delay_reg[2:0], data};
                        counter <= counter + 1;
                    end else begin
                        // Prepare to count (delay+1)*1000 cycles
                        counter <= (delay_reg + 1) * 1000;
                    end
                end
                COUNT: begin
                    // Decrement the counter
                    if (counter > 0) begin
                        counter <= counter - 1;
                        counting <= 1'b1;
                        // Output the remaining time
                        count <= counter / 1000;
                    end
                end
                DONE: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                end
            endcase
        end
    end

endmodule