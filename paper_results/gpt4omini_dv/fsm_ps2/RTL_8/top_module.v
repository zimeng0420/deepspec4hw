module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        DISCARD = 2'b00,
        BYTE1   = 2'b01,
        BYTE2   = 2'b10,
        BYTE3   = 2'b11
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @ (posedge clk) begin
        if (reset) begin
            current_state <= DISCARD;
            done <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @ (*) begin
        case (current_state)
            DISCARD: begin
                if (in[3] == 1) 
                    next_state = BYTE1;
                else 
                    next_state = DISCARD;
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = DISCARD;
                done = 1; // Generate done signal
            end
            default: begin
                next_state = DISCARD;
            end
        endcase
    end

    // Generate done signal for one clock cycle
    always @ (posedge clk) begin
        if (reset) begin
            done <= 0;
        end else if (current_state == BYTE3) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
    
endmodule