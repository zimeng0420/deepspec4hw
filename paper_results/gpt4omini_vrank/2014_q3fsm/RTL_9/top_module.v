module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        COUNT1 = 2'b10,
        COUNT2 = 2'b11
    } state_t;

    state_t current_state, next_state;
    int count_w1;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
            z <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (current_state == B) begin
            if (next_state == COUNT1 || next_state == COUNT2) begin
                count_w1 += w;
            end
            if (next_state == COUNT2) begin
                z <= (count_w1 == 2) ? 1 : 0;
                count_w1 <= 0; // Reset count after checking
            end
        end
    end

    always_comb begin
        case (current_state)
            A: begin
                if (s) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                next_state = COUNT1; // Start counting w
            end
            COUNT1: begin
                next_state = COUNT2; // Move to next counting state
            end
            COUNT2: begin
                next_state = B; // Go back to B to check again
            end
            default: begin
                next_state = A; // Default to state A
            end
        endcase
    end

endmodule