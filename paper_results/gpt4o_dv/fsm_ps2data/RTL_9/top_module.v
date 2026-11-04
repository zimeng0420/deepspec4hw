module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;
    
    reg [7:0] byte1, byte2, byte3;
    reg [1:0] current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 1'b0;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            out_bytes <= 24'b0;
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

    always @(*) begin
        done = 1'b0;
        out_bytes = 24'b0;
        case (current_state)
            IDLE: begin
                if (in[3]) 
                    next_state = BYTE1;
                else 
                    next_state = IDLE;
            end
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: begin
                next_state = IDLE;
                done = 1'b1;
                out_bytes = {byte1, byte2, byte3};
            end
            default: next_state = IDLE;
        endcase
    end

endmodule