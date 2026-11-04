module top_module (
    input clk,
    input reset,
    input w,
    output z
);

    // Define the states
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    reg [2:0] current_state, next_state;
    reg z_reg;

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            z_reg <= 0;
        end else begin
            current_state <= next_state;
            z_reg <= (current_state == E || current_state == F) ? 1 : 0;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: begin
                if (w == 0) next_state = B;
                else next_state = A;
            end
            B: begin
                if (w == 0) next_state = C;
                else next_state = D;
            end
            C: begin
                if (w == 0) next_state = E;
                else next_state = D;
            end
            D: begin
                if (w == 0) next_state = F;
                else next_state = A;
            end
            E: begin
                if (w == 0) next_state = E;
                else next_state = D;
            end
            F: begin
                if (w == 0) next_state = C;
                else next_state = D;
            end
            default: next_state = A; // Should not happen, but good practice
        endcase
    end

    assign z = z_reg;

endmodule