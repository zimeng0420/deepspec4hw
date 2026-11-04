module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        WAIT_START = 2'b00,
        BYTE_1     = 2'b01,
        BYTE_2     = 2'b10,
        BYTE_3     = 2'b11
    } state_t;
    
    // State registers
    state_t current_state, next_state;
    reg [1:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= WAIT_START;
            byte_count <= 2'b00;
            done <= 0;
        end else begin
            current_state <= next_state;
            
            // Sequentially updating the byte counter
            if (current_state == WAIT_START && in[3] == 1) 
                byte_count <= 2'b01;
            else if (current_state != WAIT_START) 
                byte_count <= byte_count + 1;

            // Output logic
            if (current_state == BYTE_3)
                done <= 1;
            else
                done <= 0;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            WAIT_START: 
                next_state = (in[3] == 1) ? BYTE_1 : WAIT_START;

            BYTE_1: 
                next_state = BYTE_2;

            BYTE_2: 
                next_state = BYTE_3;

            BYTE_3: 
                next_state = (in[3] == 1) ? BYTE_1 : WAIT_START;

            default: 
                next_state = WAIT_START;
        endcase
    end

endmodule