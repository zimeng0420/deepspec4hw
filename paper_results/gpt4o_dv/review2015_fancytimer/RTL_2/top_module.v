module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    // State encoding
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b10,
        DONE = 2'b11
    } state_t;

    reg [2:0] pattern_shift_reg;
    reg [3:0] delay_reg;
    reg [3:0] delay_counter;
    reg [12:0] count_1000;
    reg [1:0] state, next_state;

    // State machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // State transitions
    always @(*) begin
        case (state)
            IDLE: next_state = (pattern_shift_reg == 3'b110 && data == 1'b1) ? SHIFT : IDLE;
            SHIFT: next_state = (delay_counter == 4'd4) ? COUNT : SHIFT;
            COUNT: next_state = (count_1000 == 13'd0 && delay_reg == 4'd0) ? DONE : COUNT;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic and counting mechanism
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift_reg <= 3'd0;
            delay_reg <= 4'd0;
            delay_counter <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count_1000 <= 13'd1000;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    pattern_shift_reg <= {pattern_shift_reg[1:0], data};
                end
                SHIFT: begin
                    delay_reg <= {delay_reg[2:0], data};
                    delay_counter <= delay_counter + 1;
                end
                COUNT: begin
                    counting <= 1'b1;
                    if (count_1000 == 13'd0) begin
                        if (delay_reg > 0) begin
                            delay_reg <= delay_reg - 1;
                            count_1000 <= 13'd1000;
                        end
                    end else begin
                        count_1000 <= count_1000 - 1;
                    end
                    count <= delay_reg;
                end
                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule