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
    int count_w;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
            z <= 0;
            count_w <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (current_state == B) begin
            if (next_state == COUNT1 || next_state == COUNT2) begin
                if (w == 1) 
                    count_w <= count_w + 1;
                else 
                    count_w <= count_w;
            end
        end
    end

    always_comb begin
        next_state = current_state;
        z = 0;
        case (current_state)
            A: begin
                if (s) begin
                    next_state = B;
                    count_w = 0;
                end
            end
            B: begin
                if (count_w < 2) begin
                    next_state = COUNT1;
                end else if (count_w == 2) begin
                    z = 1;
                    next_state = COUNT1; 
                end else begin
                    z = 0;
                    next_state = COUNT1;
                end
            end
            COUNT1: begin
                next_state = COUNT2;
            end
            COUNT2: begin
                if (count_w == 2) begin
                    z = 1;
                end
                next_state = B; 
            end
        endcase
    end
endmodule