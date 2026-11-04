module top_module (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    reg [2:0] current_state, next_state;

    // Sequential logic for state transition
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A; // Initial state upon reset
        end
        else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state and output determination
    always @(*) begin
        case (current_state)
            A: begin
                if (w == 0)
                    next_state = B;
                else
                    next_state = A;
                z = 0;
            end
            B: begin
                if (w == 0)
                    next_state = C;
                else
                    next_state = D;
                z = 0;
            end
            C: begin
                if (w == 0)
                    next_state = E;
                else
                    next_state = D;
                z = 0;
            end
            D: begin
                if (w == 0)
                    next_state = F;
                else
                    next_state = A;
                z = 0;
            end
            E: begin
                if (w == 0)
                    next_state = E;
                else
                    next_state = D;
                z = 1;
            end
            F: begin
                if (w == 0)
                    next_state = C;
                else
                    next_state = D;
                z = 1;
            end
            default: begin
                next_state = A;
                z = 0;
            end
        endcase
    end

endmodule