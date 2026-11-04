module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    typedef enum logic [2:0] {
        STATE_IDLE = 3'b000,
        STATE_1 = 3'b001,
        STATE_11 = 3'b010,
        STATE_111 = 3'b011,
        STATE_1111 = 3'b100,
        STATE_11111 = 3'b101,
        STATE_111110 = 3'b110,
        STATE_111111 = 3'b111
    } state_t;

    state_t current_state, next_state;
    
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_IDLE;
        end else begin
            current_state <= next_state;
        end
    end
    
    always @(*) begin
        // Default outputs
        disc = 1'b0;
        flag = 1'b0;
        err = 1'b0;
        
        case (current_state)
            STATE_IDLE: begin
                next_state = in ? STATE_1 : STATE_IDLE;
            end
            STATE_1: begin
                next_state = in ? STATE_11 : STATE_IDLE;
            end
            STATE_11: begin
                next_state = in ? STATE_111 : STATE_IDLE;
            end
            STATE_111: begin
                next_state = in ? STATE_1111 : STATE_IDLE;
            end
            STATE_1111: begin
                next_state = in ? STATE_11111 : STATE_IDLE;
            end
            STATE_11111: begin
                next_state = in ? STATE_111110 : STATE_IDLE;
            end
            STATE_111110: begin
                if (in) begin
                    next_state = STATE_111111;
                end else begin
                    next_state = STATE_IDLE;
                    disc = 1'b1; // Detect and discard the zero
                end
            end
            STATE_111111: begin
                if (in) begin
                    next_state = STATE_111111;
                    err = 1'b1; // Signal an error for 7 or more 1s
                end else begin
                    next_state = STATE_IDLE;
                    flag = 1'b1; // Flag the beginning/end of a frame
                end
            end
            default: begin
                next_state = STATE_IDLE;
            end
        endcase
    end

endmodule