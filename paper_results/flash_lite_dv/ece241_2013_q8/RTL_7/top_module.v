module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Define states
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;

    // State register
    reg [1:0] state;

    // Next state logic
    reg [1:0] next_state;

    // Combinational logic for next state and output
    always_comb begin
        case (state)
            A: begin
                if (x) next_state = B;
                else next_state = A;
                z = 0;
            end
            B: begin
                if (x) next_state = B;
                else next_state = C;
                z = 0;
            end
            C: begin
                if (x) begin
                    next_state = B;
                    z = 1;
                end
                else begin
                    next_state = A;
                    z = 0;
                end
            end
            default: begin
                next_state = A;
                z = 0;
            end
        endcase
    end

    // State register update (clocked)
    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

endmodule