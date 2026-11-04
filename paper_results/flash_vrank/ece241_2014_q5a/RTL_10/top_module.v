module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    reg state;
    reg next_state;
    reg z_reg;

    // State definition
    localparam A = 0, B = 1;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    //Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (x == 1) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                next_state = B;
            end
            default: next_state = A;
        endcase
    end

    // Output logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z_reg <= 0;
        end else begin
            case (state)
                A: begin
                    z_reg <= x;
                end
                B: begin
                    z_reg <= ~x;
                end
                default: z_reg <= 0;
            endcase
        end
    end

    assign z = z_reg;

endmodule