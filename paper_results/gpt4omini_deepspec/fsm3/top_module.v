module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Output logic for the Moore state machine
    assign out = (current_state == D) ? 1'b1 : 1'b0;

    // State transition logic
    always @(*) begin
        case (current_state)
            A: next_state = (in == 1) ? B : A;
            B: next_state = (in == 1) ? B : C;
            C: next_state = (in == 1) ? D : A;
            D: next_state = (in == 1) ? B : C;
            default: next_state = A; // default case for safety
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

endmodule