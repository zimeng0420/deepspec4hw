module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        SECOND_BYTE = 2'b01,
        THIRD_BYTE = 2'b10
    } state_t;

    state_t state, next_state;

    // State transition logic
    always_ff @(posedge clk) begin
        if (reset) 
            state <= IDLE;
        else 
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        done = 0;
        case (state)
            IDLE: begin
                if (in[3] == 1)
                    next_state = SECOND_BYTE;
                else
                    next_state = IDLE;
            end

            SECOND_BYTE: begin
                next_state = THIRD_BYTE;
            end

            THIRD_BYTE: begin
                next_state = IDLE;
            end
        endcase
    end

    // Output logic
    always_ff @(posedge clk) begin
        if (reset) 
            done <= 0;
        else if (state == THIRD_BYTE) 
            done <= 1;
        else 
            done <= 0;
    end

endmodule