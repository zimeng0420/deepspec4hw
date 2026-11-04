module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        ONES_COMPLEMENT = 2'b01,
        OUTPUT = 2'b10
    } state_t;

    state_t current_state, next_state;
    reg complement_bit;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= IDLE;
            complement_bit <= 0;
            z <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == ONES_COMPLEMENT) begin
                complement_bit <= ~x;
                z <= complement_bit;
            end else if (current_state == OUTPUT) begin
                z <= complement_bit;
            end else begin
                z <= 0;
            end
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: next_state = ONES_COMPLEMENT;
            ONES_COMPLEMENT: 
                next_state = OUTPUT;
            OUTPUT: 
                next_state = OUTPUT;
            default: next_state = IDLE;
        endcase
    end
    
endmodule