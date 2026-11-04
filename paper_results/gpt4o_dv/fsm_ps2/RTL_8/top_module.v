module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    // State enumeration
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        BYTE_1 = 2'b01,
        BYTE_2 = 2'b10,
        BYTE_3 = 2'b11
    } state_t;

    // State and counter registers
    state_t state, next_state;

    // Counter to track number of bytes in a message
    reg [1:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 2'b00;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte_count <= 2'b01;
                        done <= 1'b0;
                    end
                end
                BYTE_1: begin
                    byte_count <= byte_count + 1'b1;
                end
                BYTE_2: begin
                    byte_count <= byte_count + 1'b1;
                end
                BYTE_3: begin
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3]) 
                    next_state = BYTE_1;
                else
                    next_state = IDLE;
            end
            BYTE_1: next_state = BYTE_2;
            BYTE_2: next_state = BYTE_3;
            BYTE_3: begin
                if (in[3]) 
                    next_state = BYTE_1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule