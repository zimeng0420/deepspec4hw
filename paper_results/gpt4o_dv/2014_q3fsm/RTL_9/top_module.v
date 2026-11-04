module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum logic [1:0] {STATE_A, STATE_B} state_t;
    state_t state, next_state;
    reg [1:0] w_count;
    reg [1:0] cycle_count;
    
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            w_count <= 2'b00;
            cycle_count <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
            
            if (state == STATE_B) begin
                cycle_count <= cycle_count + 1;
                if (w) w_count <= w_count + 1;
                
                if (cycle_count == 2'b10) begin
                    z <= (w_count == 2'b10);
                    w_count <= 2'b00;
                    cycle_count <= 2'b00;
                end
            end
        end
    end

    always_comb begin
        case (state)
            STATE_A: if (s) next_state = STATE_B;
                     else next_state = STATE_A;
            STATE_B: if (cycle_count == 2'b10) next_state = STATE_A;
                     else next_state = STATE_B;
            default: next_state = STATE_A;
        endcase
    end

endmodule