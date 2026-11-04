module top_module (
    input clk,
    input reset,
    input w,
    output z
);

    // Define states
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    // State variable
    reg [2:0] current_state, next_state;

    // State flip-flops
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // State table
    always @(*) begin
        case (current_state)
            A: begin
                if (w == 1) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                if (w == 1) begin
                    next_state = C;
                end else begin
                    next_state = D;
                end
            end
            C: begin
                if (w == 1) begin
                    next_state = E;
                end else begin
                    next_state = D;
                end
            end
            D: begin
                if (w == 1) begin
                    next_state = F;
                end else begin
                    next_state = A;
                end
            end
            E: begin
                if (w == 1) begin
                    next_state = E;
                end else begin
                    next_state = D;
                end
            end
            F: begin
                if (w == 1) begin
                    next_state = C;
                end else begin
                    next_state = D;
                end
            end
            default: next_state = A;
        endcase
    end

    // Output logic
    assign z = (current_state == E) || (current_state == F);


endmodule