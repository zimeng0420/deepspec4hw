module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding using one-hot
    typedef enum reg [1:0] {
        S_A = 2'b01,
        S_B = 2'b10
    } state_t;

    state_t state, next_state;

    // State transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_A;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and output logic
    always @(*) begin
        case(state)
            S_A: begin
                if (x == 1'b0) begin
                    next_state = S_A;
                    z = 1'b0;
                end else begin
                    next_state = S_B;
                    z = 1'b1;
                end
            end
            S_B: begin
                if (x == 1'b0) begin
                    next_state = S_B;
                    z = 1'b1;
                end else begin
                    next_state = S_B;
                    z = 1'b0;
                end
            end
            default: begin
                next_state = S_A;
                z = 1'b0;
            end
        endcase
    end

endmodule