module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    typedef enum reg [1:0] {
        IDLE    = 2'b00,
        SHIFT   = 2'b01,
        COUNT   = 2'b10,
        DONE    = 2'b11
    } state_t;

    reg [3:0] shift_reg;
    reg [3:0] delay_reg;
    reg [13:0] counter;
    reg [2:0] bit_counter;
    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            delay_reg <= 4'b0;
            counter <= 14'b0;
            bit_counter <= 3'b0;
            count <= 4'b0;
            counting <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};  // Shift in data
                    if (shift_reg == 4'b1101)
                        next_state <= SHIFT;
                end
                SHIFT: begin
                    shift_reg <= {shift_reg[2:0], data};  // Shift in delay bits
                    bit_counter <= bit_counter + 3'b1;
                    if (bit_counter == 3'b100) begin
                        delay_reg <= shift_reg;  // Capture delay
                        counter <= (shift_reg + 4'b0001) * 14'd1000;
                        next_state <= COUNT;
                        bit_counter <= 3'b0;
                    end 
                end
                COUNT: begin
                    counting <= 1;
                    if (counter > 0) begin
                        counter <= counter - 14'b1;
                        count <= (counter / 14'd1000);
                    end else begin
                        counting <= 0;
                        done <= 1;
                        next_state <= DONE;
                    end
                end
                DONE: begin
                    if (ack) begin
                        done <= 0;
                        next_state <= IDLE;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (shift_reg == 4'b1101) next_state = SHIFT;
            SHIFT: if (bit_counter == 3'b100) next_state = COUNT;
            COUNT: if (counter == 0) next_state = DONE;
            DONE: if (ack) next_state = IDLE;
        endcase
    end

endmodule