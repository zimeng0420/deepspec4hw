module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE = 2'b00,
        START_BIT = 2'b01,
        DATA_BITS = 2'b10,
        STOP_BIT = 2'b11
    } state_t;

    state_t current_state, next_state;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            bit_count <= 0;
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
                next_state = DATA_BITS;
                bit_count = 0;
            end
            
            DATA_BITS: begin
                if (bit_count < 8) begin
                    bit_count = bit_count + 1;
                end else begin
                    next_state = STOP_BIT;
                end
            end
            
            STOP_BIT: begin
                if (in == 1) begin
                    done = 1;
                    next_state = IDLE;
                end else begin
                    next_state = STOP_BIT; // wait for stop bit
                end
            end
        endcase
    end

endmodule