module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE,
        FIRST_BYTE,
        SECOND_BYTE,
        THIRD_BYTE
    } state_t;

    state_t current_state, next_state;
    reg [7:0] byte_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            byte_count <= 0;
            out_bytes <= 0;
            done <= 0;
        end else begin
            current_state <= next_state;
            if (next_state == FIRST_BYTE) begin
                out_bytes[23:16] <= in;
                byte_count <= 1;
            end else if (next_state == SECOND_BYTE) begin
                out_bytes[15:8] <= in;
                byte_count <= 2;
            end else if (next_state == THIRD_BYTE) begin
                out_bytes[7:0] <= in;
                byte_count <= 3;
                done <= 1;
            end else if (next_state == IDLE) begin
                done <= 0;
            end
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: begin
                if (in[3] == 1) begin
                    next_state = FIRST_BYTE;
                end else begin
                    next_state = IDLE;
                end
            end
            FIRST_BYTE: begin
                next_state = SECOND_BYTE;
            end
            SECOND_BYTE: begin
                next_state = THIRD_BYTE;
            end
            THIRD_BYTE: begin
                next_state = IDLE; // Reset to IDLE after collecting all 3 bytes
            end
            default: next_state = IDLE;
        endcase
    end

endmodule