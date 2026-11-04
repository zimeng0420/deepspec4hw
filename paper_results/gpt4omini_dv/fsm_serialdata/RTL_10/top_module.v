module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE,
        START_BIT,
        DATA_RECEIVE_0,
        DATA_RECEIVE_1,
        DATA_RECEIVE_2,
        DATA_RECEIVE_3,
        DATA_RECEIVE_4,
        DATA_RECEIVE_5,
        DATA_RECEIVE_6,
        DATA_RECEIVE_7,
        STOP_BIT,
        ERROR
    } state_t;

    state_t current_state, next_state;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            out_byte <= 8'b0;
            done <= 0;
            bit_count <= 0;
        end else begin
            current_state <= next_state;
            if (next_state == DATA_RECEIVE_0 || next_state == DATA_RECEIVE_1 || 
                next_state == DATA_RECEIVE_2 || next_state == DATA_RECEIVE_3 ||
                next_state == DATA_RECEIVE_4 || next_state == DATA_RECEIVE_5 ||
                next_state == DATA_RECEIVE_6 || next_state == DATA_RECEIVE_7) begin
                out_byte[bit_count] <= in;
            end
        end
    end

    always @* begin
        next_state = current_state;
        done = 0;

        case (current_state)
            IDLE: begin
                if (in == 0) // Detect start bit
                    next_state = START_BIT;
            end
            START_BIT: begin
                next_state = DATA_RECEIVE_0;
                bit_count = 0;
            end
            DATA_RECEIVE_0: begin
                if (bit_count < 7)
                    next_state = DATA_RECEIVE_1;
                else
                    next_state = STOP_BIT;
                bit_count = bit_count + 1;
            end
            DATA_RECEIVE_1: begin
                if (bit_count < 7)
                    next_state = DATA_RECEIVE_2;
                else
                    next_state = STOP_BIT;
                bit_count = bit_count + 1;
            end
            DATA_RECEIVE_2: begin
                if (bit_count < 7)
                    next_state = DATA_RECEIVE_3;
                else
                    next_state = STOP_BIT;
                bit_count = bit_count + 1;
            end
            DATA_RECEIVE_3: begin
                if (bit_count < 7)
                    next_state = DATA_RECEIVE_4;
                else
                    next_state = STOP_BIT;
                bit_count = bit_count + 1;
            end
            DATA_RECEIVE_4: begin
                if (bit_count < 7)
                    next_state = DATA_RECEIVE_5;
                else
                    next_state = STOP_BIT;
                bit_count = bit_count + 1;
            end
            DATA_RECEIVE_5: begin
                if (bit_count < 7)
                    next_state = DATA_RECEIVE_6;
                else
                    next_state = STOP_BIT;
                bit_count = bit_count + 1;
            end
            DATA_RECEIVE_6: begin
                if (bit_count < 7)
                    next_state = DATA_RECEIVE_7;
                else
                    next_state = STOP_BIT;
                bit_count = bit_count + 1;
            end
            DATA_RECEIVE_7: begin
                next_state = STOP_BIT;
                bit_count = bit_count + 1;
            end
            STOP_BIT: begin
                if (in == 1) begin
                    done = 1; // Stop bit valid
                    next_state = IDLE; // go back to idle
                end else begin
                    next_state = ERROR; // Error state if stop bit is not as expected
                end
            end
            ERROR: begin
                if (in == 0) // Wait for start bit again
                    next_state = START_BIT;
            end
        endcase
    end
endmodule