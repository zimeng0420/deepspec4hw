module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        BYTE1   = 2'b01,
        BYTE2   = 2'b10,
        BYTE3   = 2'b11
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            out_bytes <= 24'b0;
            done <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always_comb begin
        next_state = current_state; // Default to hold state
        out_bytes = out_bytes;       // Default output
        done = 0;                    // Default done signal

        case (current_state)
            IDLE: begin
                if (in[3] == 1) begin
                    next_state = BYTE1;
                    out_bytes[23:16] = in; // Store the first byte
                end
            end

            BYTE1: begin
                next_state = BYTE2;
                out_bytes[15:8] = in; // Store the second byte
            end

            BYTE2: begin
                next_state = BYTE3;
                out_bytes[7:0] = in; // Store the third byte
            end

            BYTE3: begin
                done = 1; // Assert done on next clock cycle
                next_state = IDLE; // Return to IDLE
            end
        endcase
    end

endmodule