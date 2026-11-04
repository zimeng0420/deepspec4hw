module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum reg [1:0] {
        IDLE = 2'b00,
        FIRST_ONE_DETECTED = 2'b01
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
                z = x;
                if (x) 
                    next_state = FIRST_ONE_DETECTED;
                else 
                    next_state = IDLE;
            end
            FIRST_ONE_DETECTED: begin
                z = ~x;
                next_state = FIRST_ONE_DETECTED;
            end
            default: begin
                z = x; // Default case for safe coding
                next_state = IDLE;
            end
        endcase
    end
endmodule