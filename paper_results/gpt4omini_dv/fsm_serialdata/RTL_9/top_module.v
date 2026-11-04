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
    reg [7:0] data;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            out_byte <= 8'b0;
            done <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @* begin
        next_state = current_state;
        done = 0;
        case (current_state)
            IDLE: begin
                if (in == 0) begin
                    next_state = START_BIT;
                end
            end
            
            START_BIT: begin
                next_state = DATA_RECEIVE_0;
            end
            
            DATA_RECEIVE_0: begin
                data[0] = in;
                bit_count = 1;
                next_state = DATA_RECEIVE_1;
            end
            
            DATA_RECEIVE_1: begin
                data[1] = in;
                bit_count = 2;
                next_state = DATA_RECEIVE_2;
            end
            
            DATA_RECEIVE_2: begin
                data[2] = in;
                bit_count = 3;
                next_state = DATA_RECEIVE_3;
            end
            
            DATA_RECEIVE_3: begin
                data[3] = in;
                bit_count = 4;
                next_state = DATA_RECEIVE_4;
            end
            
            DATA_RECEIVE_4: begin
                data[4] = in;
                bit_count = 5;
                next_state = DATA_RECEIVE_5;
            end
            
            DATA_RECEIVE_5: begin
                data[5] = in;
                bit_count = 6;
                next_state = DATA_RECEIVE_6;
            end
            
            DATA_RECEIVE_6: begin
                data[6] = in;
                bit_count = 7;
                next_state = DATA_RECEIVE_7;
            end
            
            DATA_RECEIVE_7: begin
                data[7] = in;
                bit_count = 8;
                next_state = STOP_BIT;
            end
            
            STOP_BIT: begin
                if (in == 1) begin
                    out_byte = data;
                    done = 1;
                end else begin
                    next_state = ERROR; // If stop bit is not valid
                end
            end
            
            ERROR: begin
                if (in == 0) begin
                    next_state = START_BIT; // Restart to catch the next byte
                end
            end
        endcase
    end
endmodule