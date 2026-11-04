module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    // State declaration
    typedef enum logic [1:0] {
        IDLE        = 2'b00,
        BYTE_ONE    = 2'b01,
        BYTE_TWO    = 2'b10,
        BYTE_THREE  = 2'b11
    } state_t;

    // State and next state declarations
    state_t current_state, next_state;

    // State transition and output logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always_comb begin
        done = 0;  // Default done signal is low
        case (current_state)
            IDLE: begin
                if (in[3] == 1) begin
                    next_state = BYTE_ONE;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE_ONE: begin
                next_state = BYTE_TWO;
            end
            BYTE_TWO: begin
                next_state = BYTE_THREE;
            end
            BYTE_THREE: begin
                done = 1;  // Signal done on the cycle after the third byte
                if (in[3] == 1) begin
                    next_state = BYTE_ONE; // Treat current byte as start of a new message
                end else begin
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule