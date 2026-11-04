module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    typedef enum reg [0:0] {A = 0, B = 1} state_t;
    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
        endcase
    end

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= B;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    always @(*) begin
        case (current_state)
            B: out = 1;
            A: out = 0;
        endcase
    end

endmodule