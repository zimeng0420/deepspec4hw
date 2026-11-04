module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    reg [2:0] state, next_state;
    reg [3:0] shift_reg;
    reg [3:0] delay_reg;
    reg [13:0] counter; // Counter for up to 16000 cycles.
    reg [9:0] clk_div;  // Divider for counting every 1000 clock cycles.
    reg [3:0] remaining_time;

    // State encoding
    localparam IDLE = 3'd0,
               SHIFT = 3'd1,
               COUNT = 3'd2,
               DONE = 3'd3;

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Combinational logic for state transition
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (shift_reg == 4'b1101)
                      next_state = SHIFT;
            SHIFT: if (counter == 4'd4)
                       next_state = COUNT;
            COUNT: if (counter == 14'd0)
                       next_state = DONE;
            DONE: if (ack)
                      next_state = IDLE;
        endcase
    end

    // Shift register and delay capturing
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'd0;
            delay_reg <= 4'd0;
            counter <= 14'd0;
            clk_div <= 10'd0;
            remaining_time <= 4'd0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                end
                SHIFT: begin
                    if (counter < 4)
                        delay_reg <= {delay_reg[2:0], data};
                    counter <= counter + 1;
                end
                COUNT: begin
                    if (clk_div == 10'd999) begin
                        clk_div <= 10'd0;
                        if (counter != 14'd0) begin
                            counter <= counter - 1;
                            if (counter[9:0] == 10'd0)
                                remaining_time <= remaining_time - 1;
                        end
                    end else begin
                        clk_div <= clk_div + 1;
                    end
                end
            endcase
        end
    end

    // Counting and done signals
    always @(posedge clk) begin
        case (state)
            COUNT: begin
                done <= 0;
                counting <= 1;
                if (counter == 14'd0)
                    done <= 1;
            end
            DONE: begin
                counting <= 0;
            end
            default: begin
                counting <= 0;
                done <= 0;
            end
        endcase
    end

    // Assign count output
    assign count = (counting) ? remaining_time : 4'bxxxx;

endmodule