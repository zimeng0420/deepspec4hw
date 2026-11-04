module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE,  // waiting for the first byte
        BYTE1, // received first byte
        BYTE2, // received second byte
        BYTE3  // received third byte, ready to signal done
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        done = 0; // default done is low
        
        case (state)
            IDLE: begin
                if (in[3] == 1) begin
                    next_state = BYTE1;
                end
            end
            
            BYTE1: begin
                next_state = BYTE2;
            end
            
            BYTE2: begin
                next_state = BYTE3;
            end
            
            BYTE3: begin
                done = 1; // signal done after receiving third byte
                next_state = IDLE; // reset back to IDLE
            end
            
            default: next_state = IDLE; // safety state
        endcase
    end

endmodule