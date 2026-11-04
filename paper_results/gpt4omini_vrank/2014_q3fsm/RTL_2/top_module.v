module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum reg [1:0] {A, B} state_t;
    state_t state, next_state;
    reg [2:0] w_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_count <= 0;
        end else begin
            state <= next_state;
            if (state == B) begin
                w_count <= {w_count[1:0], w}; // Shift old values and add current w
            end
        end
    end

    always @(*) begin
        case (state)
            A: begin
                if (s == 1) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
                z = 0;
            end
            B: begin
                if (w_count[2:1] + w_count[1:0] == 2) begin
                    z = 1;
                end else begin
                    z = 0;
                end
                next_state = B;  // stay in B for next cycle
            end
            default: next_state = A;
        endcase
    end

endmodule