module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State Encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;

    // Registers and variables
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [13:0] counter; // Enough to count up to 16000 cycles
    reg [9:0] inner_counter; // To count 1000 cycles

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            delay <= 4'b0000;
            counter <= 14'b0;
            inner_counter <= 10'b0;
            count <= 4'bxxxx;
            counting <= 1'b0;
            done <= 1'b0;
        end
        else begin
            state <= next_state;
            
            // State machine logic
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        shift_reg <= 4'b0000; // Reset shift_reg for next shift
                    end
                end
                
                SHIFT: begin
                    delay <= {delay[2:0], data};
                end
                
                COUNT: begin
                    if (inner_counter < 10'd999) begin
                        inner_counter <= inner_counter + 1;
                    end else begin
                        inner_counter <= 10'b0;
                        if (count > 0) begin
                            count <= count - 1;
                        end
                    end
                    if (counter > 0) begin
                        counter <= counter - 1;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

    always_comb begin
        next_state = state;
        counting = 1'b0;
        done = 1'b0;
        
        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            
            SHIFT: begin
                if (shift_reg == 4'b1101) begin // After capturing 4 delay bits, shift_reg will be zero
                    delay = shift_reg;
                    counter = (shift_reg + 1) * 1000;
                    next_state = COUNT;
                end
            end
            
            COUNT: begin
                counting = 1'b1;
                if (counter == 0) begin
                    counting = 1'b0;
                    done = 1'b1;
                    next_state = DONE;
                end
            end
            
            DONE: begin
                done = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule