module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    state_t state, next_state;
    integer byte_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 0;
            out_bytes <= 0;
            done <= 0;
        end else begin
            state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (state == BYTE1) begin
            out_bytes[23:16] <= in;
        end else if (state == BYTE2) begin
            out_bytes[15:8] <= in;
        end else if (state == BYTE3) begin
            out_bytes[7:0] <= in;
            done <= 1;
        end else begin
            done <= 0;
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1;
                    byte_count = 1;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
                byte_count = 2;
            end
            BYTE2: begin
                next_state = BYTE3;
                byte_count = 3;
            end
            BYTE3: begin
                next_state = IDLE;
                byte_count = 0;
            end
        endcase
    end
endmodule