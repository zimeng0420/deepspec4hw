module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {A, B} state_t;
    state_t state, next_state;

    // Count of w = 1 in the last three cycles
    reg [2:0] w_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_count <= 0;
        end else begin
            state <= next_state;
            if (state == B) begin
                // Shift register for counting w over three cycles
                w_count <= {w_count[1:0], w};
                if (w_count[2] + w_count[1] + w_count[0] == 2)
                    z <= 1;
                else
                    z <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            A: begin
                if (s) 
                    next_state = B;
                else 
                    next_state = A;
            end
            B: begin
                // Remain in state B to continue monitoring w
                next_state = B;
            end
        endcase
    end

endmodule