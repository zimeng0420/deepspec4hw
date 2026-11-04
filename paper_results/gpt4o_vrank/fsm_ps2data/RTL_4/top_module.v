module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum logic[1:0] {
        WAIT_FOR_START = 2'b00,
        BYTE1_RECEIVED = 2'b01,
        BYTE2_RECEIVED = 2'b10,
        BYTE3_RECEIVED = 2'b11
    } state_t;

    state_t state, next_state;
    reg [7:0] byte1, byte2;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and output logic
    always @(*) begin
        next_state = state;
        done = 1'b0;
        out_bytes = 24'bx;
        case (state)
            WAIT_FOR_START: begin
                if (in[3] == 1'b1) begin
                    next_state = BYTE1_RECEIVED;
                    byte1 = in;
                end
            end
            BYTE1_RECEIVED: begin
                next_state = BYTE2_RECEIVED;
                byte2 = in;
            end
            BYTE2_RECEIVED: begin
                next_state = BYTE3_RECEIVED;
            end
            BYTE3_RECEIVED: begin
                next_state = WAIT_FOR_START;
                done = 1'b1;
                out_bytes = {byte1, byte2, in};
            end
        endcase
    end

endmodule