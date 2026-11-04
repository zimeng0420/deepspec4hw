module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;
    state_t state, next_state;

    // Registers to store bytes
    reg [7:0] byte1, byte2, byte3;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'b0;
        end else begin
            state <= next_state;
            if (next_state == BYTE3) begin
                done <= 1'b0;
            end else if (state == BYTE3) begin
                done <= 1'b1;
                out_bytes <= {byte1, byte2, byte3};
            end
        end
    end

    // Next state logic and data path
    always @(*) begin
        next_state = state;  // Default to remain in the current state
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1;
                    byte1 <= in;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
                byte2 <= in;
            end
            BYTE2: begin
                next_state = BYTE3;
                byte3 <= in;
            end
            BYTE3: begin
                next_state = IDLE; // Transition back to IDLE after third byte
            end
        endcase
    end

endmodule