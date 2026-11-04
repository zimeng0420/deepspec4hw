module top_module (
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State encoding
    typedef enum reg [1:0] {IDLE = 2'b00, SHIFT = 2'b01, COUNT = 2'b10, DONE = 2'b11} state_t;
    state_t state, next_state;

    // Registers to store pattern
    reg [3:0] shift_reg;
    reg [3:0] delay_reg;
    reg [13:0] counter; // 14-bit counter for counting up to 16000 (15*1000 + 1000)
    
    // Synchronize state transition with clock
    always @(posedge clk) begin
        if (reset) 
            state <= IDLE;
        else 
            state <= next_state;
    end
    
    // State-transition logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: 
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;

            SHIFT: 
                if (delay_reg[3] == 1'b1) // After 4 shifts
                    next_state = COUNT;

            COUNT: 
                if (counter == 14'd0)
                    next_state = DONE;

            DONE:
                if (ack)
                    next_state = IDLE;
        endcase
    end

    // Sequential logic for shift registers and counter
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
            delay_reg <= 4'b0000;
            counter <= 14'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    done <= 1'b0;
                    counting <= 1'b0;
                end
                
                SHIFT: begin
                    delay_reg <= {delay_reg[2:0], data};
                    if (delay_reg[3] == 1'b1)
                        counter <= (delay_reg + 4'd1) * 14'd1000 - 1;
                end
                
                COUNT: begin
                    counting <= 1'b1;
                    if (counter > 0)
                        counter <= counter - 1;
                    if (counter % 1000 == 0)
                        count <= counter / 1000;
                end
                
                DONE: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    if (ack) begin
                        done <= 1'b0;
                        shift_reg <= 4'b0000;
                        delay_reg <= 4'b0000;
                        counter <= 14'd0;
                    end
                end
            endcase
        end
    end

endmodule