module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum reg [1:0] {A, B} state_t;
    state_t current_state, next_state;
    reg [2:0] count_w;  // To count the number of 1's in three clock cycles
    reg [1:0] cycle;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            count_w <= 0;
            cycle <= 0;
            z <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == B) begin
                if (cycle < 3) begin
                    if (w == 1) 
                        count_w <= count_w + 1;
                    cycle <= cycle + 1;
                end else begin
                    if (count_w == 2)
                        z <= 1;
                    else
                        z <= 0;
                    
                    // Reset for the next 3 cycles
                    count_w <= 0;
                    cycle <= 0;
                end
            end
        end
    end

    always @(*) begin
        case (current_state)
            A: begin
                if (s == 1) 
                    next_state = B;
                else 
                    next_state = A;
            end
            B: begin
                next_state = B; // stay in state B
            end
            default: next_state = A;
        endcase
    end
endmodule