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
        DATA_BITS, 
        STOP_BIT
    } state_t;

    state_t current_state, next_state;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            out_byte <= 8'b0;
            done <= 1'b0;
            bit_count <= 4'b0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = START_BIT;
                    done = 1'b0;
                end else begin
                    next_state = IDLE;
                end
            end

            START_BIT: begin
                next_state = DATA_BITS;
                bit_count = 4'b0;
            end

            DATA_BITS: begin
                if (bit_count < 8) begin
                    out_byte[bit_count] = in;
                    next_state = DATA_BITS;
                    bit_count = bit_count + 1;
                end else begin
                    next_state = STOP_BIT;
                end
            end

            STOP_BIT: begin
                if (in == 1'b1) begin
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_state = STOP_BIT;
                end
            end

            default: next_state = IDLE;
        endcase
    end
endmodule