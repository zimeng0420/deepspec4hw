module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    typedef enum reg [0:0] {B = 1'b0, A = 1'b1} state_t; 
    state_t state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // Shouldn't happen but handles unknown states
        endcase
    end

    // State update logic (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= B; // Synchronous reset to state B
        end else begin
            state <= next_state;
        end
    end

    // Output logic (combinational)
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule