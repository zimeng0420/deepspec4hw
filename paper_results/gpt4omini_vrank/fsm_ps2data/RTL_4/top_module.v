module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);
    typedef enum reg [1:0] {IDLE, BYTE1, BYTE2, BYTE3} state_t;
    state_t state, next_state;
    reg [2:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 3'b000;
            out_bytes <= 24'b0;
            done <= 0;
        end else begin
            state <= next_state;
            if (next_state == BYTE1) begin
                out_bytes[23:16] <= in;
            end else if (next_state == BYTE2) begin
                out_bytes[15:8] <= in;
            end else if (next_state == BYTE3) begin
                out_bytes[7:0] <= in;
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3] == 1) begin
                    next_state = BYTE1;
                    byte_count = 3'b001;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
                byte_count = 3'b010;
            end
            BYTE2: begin
                next_state = BYTE3;
                byte_count = 3'b011;
            end
            BYTE3: begin
                next_state = IDLE;
                byte_count = 3'b000; // Reset for next message
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule