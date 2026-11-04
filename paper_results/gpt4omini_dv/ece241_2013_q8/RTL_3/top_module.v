module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    typedef enum reg [1:0] {S0, S1, S2} state_t;
    state_t state, next_state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case(state)
            S0: begin
                if (x == 1'b1) begin
                    next_state = S1;
                end else begin
                    next_state = S0;
                end
                z = 1'b0;
            end
            S1: begin
                if (x == 1'b0) begin
                    next_state = S2;
                end else begin
                    next_state = S1; // Stay in S1
                end
                z = 1'b0;
            end
            S2: begin
                if (x == 1'b1) begin
                    next_state = S1;
                    z = 1'b1; // Output logic for '101' detected
                end else begin
                    next_state = S0;
                    z = 1'b0;
                end
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end
endmodule