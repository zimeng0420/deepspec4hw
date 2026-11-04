module top_module (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding
    parameter A = 3'b000;
    parameter B = 3'b001;
    parameter C = 3'b010;
    parameter D = 3'b011;
    parameter E = 3'b100;
    parameter F = 3'b101;

    // State register
    reg [2:0] current_state, next_state;

    // Output register
    reg z_reg;

    // State flip-flops
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        case (current_state)
            A: begin
                if (w)
                    next_state = B;
                else
                    next_state = A;
                z_reg = 0;
            end
            B: begin
                if (w)
                    next_state = C;
                else
                    next_state = D;
                z_reg = 0;
            end
            C: begin
                if (w)
                    next_state = E;
                else
                    next_state = D;
                z_reg = 0;
            end
            D: begin
                if (w)
                    next_state = F;
                else
                    next_state = A;
                z_reg = 0;
            end
            E: begin
                if (w)
                    next_state = E;
                else
                    next_state = D;
                z_reg = 1;
            end
            F: begin
                if (w)
                    next_state = C;
                else
                    next_state = D;
                z_reg = 1;
            end
            default: begin
                next_state = A;
                z_reg = 0;
            end
        endcase
    end

    assign z = z_reg;

endmodule