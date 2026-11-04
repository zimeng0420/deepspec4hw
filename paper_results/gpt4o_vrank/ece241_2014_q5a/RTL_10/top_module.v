module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        INVERT = 2'b01,
        PASS = 2'b10
    } state_t;

    state_t state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (!areset)
                    next_state = INVERT;
                else
                    next_state = IDLE;
            end
            INVERT: begin
                if (x == 1)
                    next_state = PASS;
                else
                    next_state = INVERT;
            end
            PASS: begin
                next_state = PASS;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 0;
        end else begin
            case (state)
                INVERT: z <= !x;
                PASS: z <= x;
                default: z <= 0;
            endcase
        end
    end

endmodule