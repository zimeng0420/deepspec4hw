module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE, 
        BYTE1, 
        BYTE2, 
        BYTE3
    } state_t;

    state_t current_state, next_state;
    reg [7:0] byte_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            out_bytes <= 24'b0;
            done <= 0;
            byte_count <= 0;
        end else begin
            current_state <= next_state;
            if (next_state == BYTE1) begin
                out_bytes[23:16] <= in;
                byte_count <= 1;
            end else if (next_state == BYTE2) begin
                out_bytes[15:8] <= in;
                byte_count <= 2;
            end else if (next_state == BYTE3) begin
                out_bytes[7:0] <= in;
                done <= 1;
                byte_count <= 3;
            end else begin
                done <= 0;
            end
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (in[3] == 1) 
                    next_state = BYTE1;
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule