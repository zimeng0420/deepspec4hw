module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
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

    state_t state, next_state;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            out_byte <= 0;
            bit_count <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        // Default next state
        next_state = state;
        done = 0;

        case (state)
            IDLE: begin
                if (in == 0) begin // Detect start bit
                    next_state = START_BIT;
                    bit_count = 0;
                end
            end

            START_BIT: begin
                if (bit_count == 0) begin
                    next_state = DATA_RECEIVE_0;
                end
            end

            DATA_RECEIVE_0: begin
                out_byte[0] = in; // Capture the first data bit
                bit_count = 1;
                next_state = DATA_RECEIVE_1;
            end
            
            DATA_RECEIVE_1: begin
                out_byte[1] = in;
                bit_count = 2;
                next_state = DATA_RECEIVE_2;
            end
            
            DATA_RECEIVE_2: begin
                out_byte[2] = in;
                bit_count = 3;
                next_state = DATA_RECEIVE_3;
            end
            
            DATA_RECEIVE_3: begin
                out_byte[3] = in;
                bit_count = 4;
                next_state = DATA_RECEIVE_4;
            end
            
            DATA_RECEIVE_4: begin
                out_byte[4] = in;
                bit_count = 5;
                next_state = DATA_RECEIVE_5;
            end
            
            DATA_RECEIVE_5: begin
                out_byte[5] = in;
                bit_count = 6;
                next_state = DATA_RECEIVE_6;
            end
            
            DATA_RECEIVE_6: begin
                out_byte[6] = in;
                bit_count = 7;
                next_state = DATA_RECEIVE_7;
            end
            
            DATA_RECEIVE_7: begin
                out_byte[7] = in; // Last data bit
                bit_count = 8;
                next_state = STOP_BIT;
            end
            
            STOP_BIT: begin
                if (in == 1) begin // Check for stop bit
                    done = 1; // Assert done
                    next_state = IDLE; // Ready for next byte
                end else begin
                    next_state = ERROR; // Error state if stop bit not high
                end
            end
            
            ERROR: begin
                if (in == 1) begin // Wait for a valid stop bit
                    next_state = IDLE;
                end
            end
            
            default: next_state = IDLE; // Safety default
        endcase
    end
endmodule