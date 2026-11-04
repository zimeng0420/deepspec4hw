module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    typedef enum reg [2:0] {
        IDLE       = 3'd0,
        ONE_1      = 3'd1,
        TWO_1S     = 3'd2,
        THREE_1S   = 3'd3,
        FOUR_1S    = 3'd4,
        FIVE_1S    = 3'd5,
        SIX_1S     = 3'd6,
        ERROR      = 3'd7
    } state_t;
    
    state_t current_state, next_state;
    
    // State transition logic
    always_comb begin
        case (current_state)
            IDLE:    next_state = (in ? ONE_1 : IDLE);
            ONE_1:   next_state = (in ? TWO_1S : IDLE);
            TWO_1S:  next_state = (in ? THREE_1S : IDLE);
            THREE_1S: next_state = (in ? FOUR_1S : IDLE);
            FOUR_1S: next_state = (in ? FIVE_1S : IDLE);
            FIVE_1S: next_state = (in ? SIX_1S : (IDLE));
            SIX_1S:  next_state = (in ? ERROR : IDLE);
            ERROR:   next_state = (in ? ERROR : IDLE);
            default: next_state = IDLE;
        endcase
    end

    // State register logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
        end
    end

    // Output logic
    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end
        else begin
            disc <= (current_state == FIVE_1S && next_state == IDLE && in == 0);
            flag <= (current_state == SIX_1S && next_state == IDLE && in == 0);
            err  <= (current_state == ERROR);
        end
    end

endmodule