module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);
    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        START_BIT = 3'b001,
        DATA_RECEIVE_0 = 3'b010,
        DATA_RECEIVE_1 = 3'b011,
        DATA_RECEIVE_2 = 3'b100,
        DATA_RECEIVE_3 = 3'b101,
        DATA_RECEIVE_4 = 3'b110,
        DATA_RECEIVE_5 = 3'b111,
        DATA_RECEIVE_6 = 4'b1000,
        DATA_RECEIVE_7 = 4'b1001,
        STOP_BIT = 4'b1010
    } state_t;

    state_t current_state, next_state;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            out_byte <= 8'b0;
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
                if (in == 0) begin // Detect start bit
                    next_state = START_BIT;
                end
            end
            START_BIT: begin
                next_state = DATA_RECEIVE_0;
            end
            DATA_RECEIVE_0: begin
                out_byte[0] = in;
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
                out_byte[7] = in;
                bit_count = 8;
                next_state = STOP_BIT;
            end
            STOP_BIT: begin
                if (in == 1) begin // Verify stop bit
                    done = 1;
                end else begin
                    next_state = IDLE; // Stay in STOP_BIT until valid stop
                end
            end
        endcase
    end
endmodule