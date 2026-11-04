module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum logic [2:0] {
        IDLE,
        START,
        RECEIVE,
        STOP
    } state_t;

    state_t current_state, next_state;
    logic [3:0] bit_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            out_byte <= 8'b0;
            done <= 0;
            bit_count <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == RECEIVE) begin
                out_byte <= {in, out_byte[7:1]};
            end
        end
    end

    always_ff @(current_state or in) begin
        case (current_state)
            IDLE: begin
                done <= 0;
                if (in == 1'b0) begin
                    next_state = START;
                end else begin
                    next_state = IDLE;
                end
            end

            START: begin
                if (in == 1'b0) begin
                    next_state = RECEIVE;
                    bit_count = 0;
                end else begin
                    next_state = IDLE;
                end
            end
            
            RECEIVE: begin
                if (bit_count < 8) begin
                    next_state = RECEIVE;
                    bit_count = bit_count + 1;
                end else begin
                    next_state = STOP;
                end
            end
            
            STOP: begin
                if (in == 1'b1) begin
                    done <= 1;
                    next_state = IDLE;
                end else begin
                    next_state = STOP;
                end
            end
            
            default: next_state = IDLE;
        endcase
    end
endmodule