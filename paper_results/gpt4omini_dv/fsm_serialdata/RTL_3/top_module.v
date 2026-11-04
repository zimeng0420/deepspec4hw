module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum logic [2:0] {
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
    reg [3:0] bit_counter;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            out_byte <= 8'b0;
            done <= 0;
            bit_counter <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (current_state == DATA_RECEIVE_0) begin
            out_byte[0] <= in;
        end else if (current_state == DATA_RECEIVE_1) begin
            out_byte[1] <= in;
        end else if (current_state == DATA_RECEIVE_2) begin
            out_byte[2] <= in;
        end else if (current_state == DATA_RECEIVE_3) begin
            out_byte[3] <= in;
        end else if (current_state == DATA_RECEIVE_4) begin
            out_byte[4] <= in;
        end else if (current_state == DATA_RECEIVE_5) begin
            out_byte[5] <= in;
        end else if (current_state == DATA_RECEIVE_6) begin
            out_byte[6] <= in;
        end else if (current_state == DATA_RECEIVE_7) begin
            out_byte[7] <= in;
        end
    end

    always_comb begin
        next_state = current_state;
        done = 0;

        case (current_state)
            IDLE: begin
                if (in == 0)  // Start bit detected
                    next_state = START_BIT;
            end

            START_BIT: begin
                next_state = DATA_RECEIVE_0;
            end

            DATA_RECEIVE_0: next_state = DATA_RECEIVE_1;
            DATA_RECEIVE_1: next_state = DATA_RECEIVE_2;
            DATA_RECEIVE_2: next_state = DATA_RECEIVE_3;
            DATA_RECEIVE_3: next_state = DATA_RECEIVE_4;
            DATA_RECEIVE_4: next_state = DATA_RECEIVE_5;
            DATA_RECEIVE_5: next_state = DATA_RECEIVE_6;
            DATA_RECEIVE_6: next_state = DATA_RECEIVE_7;
            DATA_RECEIVE_7: next_state = STOP_BIT;

            STOP_BIT: begin
                if (in == 1) begin  // Stop bit detected
                    done = 1;
                end else begin
                    next_state = ERROR;  // Unexpected stop bit
                end
            end

            ERROR: begin
                if (in == 1)  // If stop bit received, reset back to IDLE
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end
endmodule