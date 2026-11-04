module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum reg [1:0] {READY = 2'b00, INVERT = 2'b01, PASS = 2'b10} state_t;
    state_t state, next_state;
    reg carry;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= READY;
            z <= 1'b0;
            carry <= 1'b1;
        end else begin
            state <= next_state;
            z <= (state == INVERT) ? ~x : x ^ carry;
            if (state == READY) begin
                carry <= 1'b1;
            end else if (state == INVERT) begin
                carry <= carry & ~x;
            end
        end
    end

    always @(*) begin
        case(state)
            READY: next_state = (areset) ? READY : INVERT;
            INVERT: next_state = PASS;
            PASS: next_state = PASS;
            default: next_state = READY;
        endcase
    end
endmodule