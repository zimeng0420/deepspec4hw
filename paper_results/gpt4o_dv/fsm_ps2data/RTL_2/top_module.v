module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    // State definitions
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    state_t state, next_state;

    // Byte storage registers
    reg [7:0] byte1, byte2, byte3;

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and output logic
    always @(*) begin
        // Default values
        next_state = state;
        done = 1'b0;
        out_bytes = 24'bx;

        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1;
                end
            end
            
            BYTE1: begin
                byte1 = in;
                next_state = BYTE2;
            end
            
            BYTE2: begin
                byte2 = in;
                next_state = BYTE3;
            end
            
            BYTE3: begin
                byte3 = in;
                out_bytes = {byte1, byte2, byte3};
                done = 1'b1;
                next_state = IDLE;  // Return to IDLE after done signal
            end
        endcase
    end
endmodule