module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum reg [1:0] {
        STATE_A = 2'd0,
        STATE_B = 2'd1
    } state_t;

    state_t state, next_state;
    reg [1:0] w_count;  // To count the number of 1's in the last 3 cycles of w
    reg [1:0] cycle_count;  // To count the 3 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            w_count <= 2'd0;
            cycle_count <= 2'd0;
            z <= 0;
        end else begin
            state <= next_state;

            if (state == STATE_B) begin
                cycle_count <= cycle_count + 1;
                w_count <= w_count + w;
                
                if (cycle_count == 2'd2) begin
                    if (w_count + w == 2'd2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                end
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            STATE_A: begin
                if (s == 1) begin
                    next_state = STATE_B;
                end
            end
            STATE_B: begin
                if (cycle_count == 2'd2) begin
                    next_state = STATE_B;
                end
            end
        endcase
    end

endmodule