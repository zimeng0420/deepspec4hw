module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum logic [1:0] {
        STATE_A = 2'b00,
        STATE_B = 2'b01,
        STATE_C = 2'b10
    } state_t;
    
    state_t state, next_state;
    reg [1:0] w_count;
    reg [1:0] cycle_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            w_count <= 0;
            cycle_count <= 0;
            z <= 0;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        z = 0;
        
        case (state)
            STATE_A: begin
                if (s == 1) begin
                    next_state = STATE_B;
                    w_count = 0;
                    cycle_count = 0;
                end
            end
            STATE_B: begin
                cycle_count = cycle_count + 1;
                if (w) w_count = w_count + 1;

                if (cycle_count == 3) begin
                    if (w_count == 2) 
                        z = 1;

                    w_count = 0;
                    cycle_count = 0;
                end
            end
        endcase
    end

endmodule