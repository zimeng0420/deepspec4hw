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
        end
    end

    always @(*) begin
        next_state = current_state;
        done = 0;

        case (current_state)
            IDLE: begin
                if (in == 0) // Start bit detected
                    next_state = START_BIT;
            end
            
            START_BIT: begin
                bit_count = 0;
                next_state = DATA_RECEIVE_0;
            end
            
            DATA_RECEIVE_0: begin
                out_byte[0] = in;
                bit_count = 1;
                next_state = (bit_count < 8) ? DATA_RECEIVE_1 : STOP_BIT;
            end
            
            DATA_RECEIVE_1: begin
                out_byte[1] = in;
                bit_count = 2;
                next_state = (bit_count < 8) ? DATA_RECEIVE_2 : STOP_BIT;
            end
            
            DATA_RECEIVE_2: begin
                out_byte[2] = in;
                bit_count = 3;
                next_state = (bit_count < 8) ? DATA_RECEIVE_3 : STOP_BIT;
            end
            
            DATA_RECEIVE_3: begin
                out_byte[3] = in;
                bit_count = 4;
                next_state = (bit_count < 8) ? DATA_RECEIVE_4 : STOP_BIT;
            end
            
            DATA_RECEIVE_4: begin
                out_byte[4] = in;
                bit_count = 5;
                next_state = (bit_count < 8) ? DATA_RECEIVE_5 : STOP_BIT;
            end
            
            DATA_RECEIVE_5: begin
                out_byte[5] = in;
                bit_count = 6;
                next_state = (bit_count < 8) ? DATA_RECEIVE_6 : STOP_BIT;
            end
            
            DATA_RECEIVE_6: begin
                out_byte[6] = in;
                bit_count = 7;
                next_state = (bit_count < 8) ? DATA_RECEIVE_7 : STOP_BIT;
            end
            
            DATA_RECEIVE_7: begin
                out_byte[7] = in;
                bit_count = 8;
                next_state = STOP_BIT;
            end
            
            STOP_BIT: begin
                if (in == 1) begin
                    done = 1; // Valid stop bit
                    next_state = IDLE;
                end else begin
                    next_state = ERROR; // Error: stop bit not received
                end
            end
            
            ERROR: begin
                if (in == 1) begin
                    next_state = IDLE; // Wait for next start bit
                end
            end
        endcase
    end

endmodule