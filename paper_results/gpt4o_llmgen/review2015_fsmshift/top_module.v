module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        SHIFT_ENABLE_1 = 2'b01,
        SHIFT_ENABLE_2 = 2'b10,
        SHIFT_ENABLE_3 = 2'b11
    } state_type;
    
    state_type state, next_state;
    reg [1:0] cycle_count;
    
    // State Transition Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SHIFT_ENABLE_1; // Start shift enable after reset
            cycle_count <= 2'b00;    // Initialize cycle count
        end else begin
            state <= next_state;     // Move to the next state
        end
    end
    
    // Next State Logic
    always @(*) begin
        case (state)
            IDLE: begin
                shift_ena = 1'b0; // Remain low until reset
                next_state = IDLE; // Stay in IDLE until reset
            end
            
            SHIFT_ENABLE_1: begin
                shift_ena = 1'b1;
                next_state = SHIFT_ENABLE_2;
            end

            SHIFT_ENABLE_2: begin
                shift_ena = 1'b1;
                next_state = SHIFT_ENABLE_3;
            end

            SHIFT_ENABLE_3: begin
                shift_ena = 1'b1;
                next_state = IDLE; // Move to IDLE after 4 cycles
            end
            
            default: begin
                shift_ena = 1'b0;
                next_state = IDLE;
            end
        endcase
    end

endmodule