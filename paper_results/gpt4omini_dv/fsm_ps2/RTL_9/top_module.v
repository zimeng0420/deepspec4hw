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
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= DISCARD;
            done <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @* begin
        case (current_state)
            DISCARD: begin
                if (in[3]) 
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
            end
            default: next_state = DISCARD;
        endcase
    end

    // Done signal generation
    always @(posedge clk) begin
        if (current_state == BYTE3) 
            done <= 1;
        else 
            done <= 0;
    end

endmodule