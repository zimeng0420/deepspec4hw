module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State definitions
    typedef enum reg [2:0] {
        IDLE        = 3'b000,
        START       = 3'b001,
        RECEIVE     = 3'b010,
        STOP        = 3'b011,
        ERROR       = 3'b100
    } fsm_state_t;

    fsm_state_t state, next_state;
    reg [3:0] bit_count;  // 4-bit counter to count 0 to 9
    reg [7:0] shift_reg;  // 8-bit shift register to store data byte

    // Sequential logic for state transitions and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            shift_reg <= 8'b0;
            done <= 1'b0;
        end
        else begin
            state <= next_state;
            
            if (state == RECEIVE) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1'b1;
            end

            if (state == STOP && in == 1'b1) begin
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    // Combinational logic for next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 0)
                    next_state = START;
                else
                    next_state = IDLE;
            end
            
            START: begin
                next_state = RECEIVE;
                bit_count = 4'd0;  // Reset bit counter at the start of reception
            end
            
            RECEIVE: begin
                if (bit_count == 4'd8)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            
            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule