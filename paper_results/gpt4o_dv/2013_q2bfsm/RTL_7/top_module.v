module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum logic [2:0] {
        STATE_A = 3'd0,
        STATE_B = 3'd1,
        STATE_C = 3'd2,
        STATE_D = 3'd3,
        STATE_E = 3'd4,
        STATE_F = 3'd5
    } state_t;
    
    state_t state, next_state;
    reg [1:0] y_count;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            f <= 0;
            g <= 0;
            y_count <= 0;
        end else begin
            state <= next_state;
            
            if (state == STATE_A) f <= 1;
            else f <= 0;
            
            if ((state == STATE_D) && (y == 1)) g <= 1;
            else if (state == STATE_C) g <= 1;
            else if ((state == STATE_E) || (state == STATE_F)) g <= g;
            else g <= 0;

            if (state == STATE_D) 
                y_count <= y_count + 1;
            else 
                y_count <= 0;
        end
    end

    always @(*) begin
        case (state)
            STATE_A: begin
                next_state = STATE_B;
            end
            STATE_B: begin
                next_state = STATE_C;
            end
            STATE_C: begin
                if (x == 1)
                    next_state = STATE_D;
                else
                    next_state = STATE_B;
            end
            STATE_D: begin
                if (y_count >= 2)
                    next_state = STATE_E;
                else if (y == 1)
                    next_state = STATE_F;
                else 
                    next_state = STATE_D;
            end
            STATE_E: begin
                next_state = STATE_E;
            end
            STATE_F: begin
                next_state = STATE_F;
            end
            default: next_state = STATE_A;
        endcase
    end

endmodule