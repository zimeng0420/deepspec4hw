module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        START = 3'b001,
        DATA = 3'b010,
        STOP = 3'b011,
        ERROR = 3'b100
    } state_t;

    state_t state, next_state;
    reg [2:0] data_bit_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_bit_count <= 3'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == START) data_bit_count <= 3'd0;
            else if (state == DATA) data_bit_count <= data_bit_count + 3'd1;
            
            if (state == STOP && in == 1'b1) done <= 1'b1;
            else done <= 1'b0; 
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
            end

            START: begin
                next_state = DATA;
            end

            DATA: begin
                if (data_bit_count == 3'd7)
                    next_state = STOP;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule