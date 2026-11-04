module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    typedef enum reg [2:0] {
        IDLE        = 3'b000,
        ONE         = 3'b001,
        TWO         = 3'b010,
        THREE       = 3'b011,
        FOUR        = 3'b100,
        FIVE        = 3'b101,
        SIX         = 3'b110,
        ERROR       = 3'b111
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        disc = 0;
        flag = 0;
        err = 0;

        case (state)
            IDLE: begin
                if (in) next_state = ONE;
            end
            ONE: begin
                if (in) next_state = TWO;
                else next_state = IDLE;
            end
            TWO: begin
                if (in) next_state = THREE;
                else next_state = IDLE;
            end
            THREE: begin
                if (in) next_state = FOUR;
                else next_state = IDLE;
            end
            FOUR: begin
                if (in) next_state = FIVE;
                else next_state = IDLE;
            end
            FIVE: begin
                if (in) next_state = SIX;
                else next_state = IDLE;
            end
            SIX: begin
                if (in) next_state = ERROR;
                else begin
                    flag = 1; // Detected 01111110
                    next_state = IDLE;
                end
            end
            ERROR: begin
                err = 1; // Detected 01111111...
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk) begin
        if (next_state == SIX && !in) begin
            disc = 1; // Signal to discard the bit
        end
    end

endmodule