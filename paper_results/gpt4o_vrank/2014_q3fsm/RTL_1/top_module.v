module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum reg [1:0] {A, B, C, D, E} state_t;
    state_t current_state, next_state;

    reg [1:0] w_counter;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            w_counter <= 0;
            z <= 0;
        end
        else begin
            current_state <= next_state;
            if (current_state == D) begin
                if (w_counter == 2)
                    z <= 1;
                else
                    z <= 0;
                w_counter <= 0; // Reset counter after checking
            end
            else if (current_state == B || current_state == C) begin
                if (w)
                    w_counter <= w_counter + 1;
            end
        end
    end

    always @(*) begin
        case (current_state)
            A: begin
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: next_state = C;
            C: next_state = D;
            D: next_state = B;
            default: next_state = A; // Default state
        endcase
    end
endmodule