module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    // State Declaration
    typedef enum logic [1:0] {
        IDLE,   // Waiting for in[3] = 1
        BYTE1,  // First byte of the message detected
        BYTE2,  // Second byte of the message detected
        BYTE3   // Third byte of the message detected
    } state_t;

    state_t current_state, next_state;
    reg [7:0] byte1, byte2, byte3; // Message byte storage

    // State Transition Logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end
        else begin
            current_state <= next_state;
            case (next_state)
                BYTE1: byte1 <= in;
                BYTE2: byte2 <= in;
                BYTE3: byte3 <= in;
            endcase
        end
    end

    // Next State Logic
    always_comb begin
        // Default assignments for combinational signals
        next_state = current_state;
        done = 1'b0;
        out_bytes = 24'b0;

        case (current_state)
            IDLE: begin
                if (in[3])      // Detect start of message
                    next_state = BYTE1;
            end
            BYTE1: next_state = BYTE2;    // Move to second byte
            BYTE2: next_state = BYTE3;    // Move to third byte
            BYTE3: begin
                next_state = IDLE;        // Return to IDLE after third byte
                done = 1'b1;              // Signal done
                out_bytes = {byte1, byte2, byte3};
            end
        endcase
    end

endmodule