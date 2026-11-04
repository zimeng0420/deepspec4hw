module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);
    typedef enum logic [1:0] {
        A, B, COUNT_0, COUNT_1, COUNT_2, OUTPUT
    } state_t;

    state_t state, next_state;
    int count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            count <= 0;
            z <= 0;
        end else begin
            state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (state == B) begin
            count <= count + (w ? 1 : 0);
        end else if (state == OUTPUT) begin
            if (count == 2) z <= 1;
            else z <= 0;
            count <= 0;  // Reset count for the next sequence
        end else begin
            z <= 0;  // Default output
        end
    end

    always_comb begin
        case (state)
            A: begin
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (count < 3)
                    next_state = COUNT_0;
                else
                    next_state = OUTPUT;
            end
            COUNT_0: begin
                if (count < 2)
                    next_state = COUNT_1;
                else
                    next_state = OUTPUT;
            end
            COUNT_1: begin
                if (count < 2)
                    next_state = COUNT_2;
                else
                    next_state = OUTPUT;
            end
            COUNT_2: begin
                next_state = OUTPUT;
            end
            OUTPUT: begin
                next_state = B;  // Go back to state B for the next cycle
            end
        endcase
    end
endmodule