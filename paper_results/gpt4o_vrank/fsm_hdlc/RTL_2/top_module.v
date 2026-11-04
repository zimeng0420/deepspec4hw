module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum logic [3:0] {
        ZERO = 4'b0000,
        ONE = 4'b0001,
        TWO = 4'b0010,
        THREE = 4'b0011,
        FOUR = 4'b0100,
        FIVE = 4'b0101,
        SIX = 4'b0110,
        SEVEN = 4'b0111,
        ERROR = 4'b1000
    } state_t;

    state_t state, next_state;

    // State transition logic (Synchronous reset)
    always_ff @(posedge clk) begin
        if (reset)
            state <= ZERO;
        else
            state <= next_state;
    end

    // Next state logic & output logic
    always_comb begin
        // Default outputs
        disc = 0;
        flag = 0;
        err = 0;
        
        case (state)
            ZERO: begin
                if (in)
                    next_state = ONE;
                else
                    next_state = ZERO;
            end
            ONE: begin
                if (in)
                    next_state = TWO;
                else
                    next_state = ZERO;
            end
            TWO: begin
                if (in)
                    next_state = THREE;
                else
                    next_state = ZERO;
            end
            THREE: begin
                if (in)
                    next_state = FOUR;
                else
                    next_state = ZERO;
            end
            FOUR: begin
                if (in)
                    next_state = FIVE;
                else
                    next_state = ZERO;
            end
            FIVE: begin
                if (in)
                    next_state = SIX;
                else
                    next_state = ZERO;
            end
            SIX: begin
                if (in) begin
                    next_state = SEVEN;
                    err = 1;
                end else begin
                    next_state = ZERO;
                    flag = 1;
                end
            end
            SEVEN: begin
                if (in) begin
                    next_state = ERROR;
                    err = 1;
                end else begin
                    next_state = ZERO;
                    disc = 1;
                end
            end
            ERROR: begin
                if (in)
                    next_state = ERROR;
                else
                    next_state = ZERO;
            end
            default: begin
                next_state = ZERO; // Default state
            end
        endcase
    end
endmodule