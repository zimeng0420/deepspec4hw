module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum reg [1:0] {A, B} state_t;
    state_t state, next_state;

    reg [2:0] w_counter;
    reg [2:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            z <= 0;
            w_counter <= 0;
            count <= 0;
        end else begin
            state <= next_state;
            // Update count based on previous state
            if (state == B) begin
                w_counter <= {w_counter[1:0], w}; // Shift in current w
                count <= (w_counter[2] + w_counter[1] + w_counter[0]);
            end
        end
    end

    always @* begin
        // Default values
        next_state = state;
        z = 0;

        case (state)
            A: begin
                if (s) next_state = B;
            end
            B: begin
                if (count == 2) begin
                    z = 1;
                end else begin
                    z = 0;
                end
            end
        endcase
    end

endmodule