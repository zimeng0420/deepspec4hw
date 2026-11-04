module top_module (
    input clk,
    input in,
    input reset,
    output done
);

    typedef enum logic [2:0] {
        IDLE = 3'b000,
        START_BIT = 3'b001,
        DATA_BIT_0 = 3'b010,
        DATA_BIT_1 = 3'b011,
        DATA_BIT_2 = 3'b100,
        DATA_BIT_3 = 3'b101,
        DATA_BIT_4 = 3'b110,
        DATA_BIT_5 = 3'b111,
        DATA_BIT_6 = 3'b001,
        DATA_BIT_7 = 3'b010,
        STOP_BIT = 3'b011
    } state_t;

    state_t current_state, next_state;
    
    reg [2:0] bit_count;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            bit_count <= 0;
        end else begin
            current_state <= next_state;
            if (current_state >= DATA_BIT_0 && current_state <= DATA_BIT_7)
                bit_count <= bit_count + 1;
            else
                bit_count <= 0;
        end
    end

    // State logic
    always @(*) begin
        done = 0;
        case (current_state)
            IDLE: begin
                if (in == 0)
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end
            START_BIT: begin
                next_state = DATA_BIT_0;
            end
            DATA_BIT_0, DATA_BIT_1, DATA_BIT_2, DATA_BIT_3,
            DATA_BIT_4, DATA_BIT_5, DATA_BIT_6, DATA_BIT_7: begin
                if (bit_count < 7)
                    next_state = current_state + 1;
                else
                    next_state = STOP_BIT;
            end
            STOP_BIT: begin
                if (in == 1) begin
                    done = 1;
                    next_state = IDLE;
                end else
                    next_state = STOP_BIT;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule