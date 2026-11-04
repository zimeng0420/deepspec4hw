module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum reg [1:0] {
        WAIT_FOR_ONE = 2'b00,
        EMIT_ZERO = 2'b01,
        FLIP = 2'b10,
        EMIT_ONE = 2'b11
    } state_t;

    state_t state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT_FOR_ONE;
        end 
        else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            WAIT_FOR_ONE: begin
                if (x == 1'b1) begin
                    next_state = EMIT_ZERO;
                end 
                else begin
                    next_state = WAIT_FOR_ONE;
                end
            end

            EMIT_ZERO: begin
                next_state = FLIP;
            end

            FLIP: begin
                if (x == 1'b1) begin
                    next_state = EMIT_ONE;
                end 
                else begin
                    next_state = FLIP;
                end
            end

            EMIT_ONE: begin
                next_state = EMIT_ONE;
            end

            default: begin
                next_state = WAIT_FOR_ONE;
            end
        endcase
    end

    always @(*) begin
        case (state)
            WAIT_FOR_ONE: begin
                z = 1'b0;
            end

            EMIT_ZERO: begin
                z = 1'b0;
            end

            FLIP: begin
                z = ~x;
            end

            EMIT_ONE: begin
                z = 1'b1;
            end

            default: begin
                z = 1'b0;
            end
        endcase
    end

endmodule