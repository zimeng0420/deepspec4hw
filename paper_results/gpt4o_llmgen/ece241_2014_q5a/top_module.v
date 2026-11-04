module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BIT_COPY = 2'b01,
        FLIP_BITS = 2'b10
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            IDLE: begin
                next_state = BIT_COPY;
            end
            BIT_COPY: begin
                if (x == 1'b1) begin
                    next_state = FLIP_BITS;
                end else begin
                    next_state = BIT_COPY;
                end
            end
            FLIP_BITS: begin
                next_state = FLIP_BITS;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Output logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 1'b0;
        end else begin
            case (current_state)
                BIT_COPY: z <= x;
                FLIP_BITS: z <= ~x;
                default: z <= 1'b0;
            endcase
        end
    end

endmodule