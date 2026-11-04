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

    state_t current_state, next_state;
    reg [2:0] byte_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            byte_count <= 0;
            out_bytes <= 24'b0;
            done <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        case (current_state)
            IDLE: begin
                if (in[3]) begin
                    next_state <= BYTE1;
                    byte_count <= 1;
                    out_bytes[23:16] <= in;
                end else begin
                    next_state <= IDLE;
                end
            end
            BYTE1: begin
                next_state <= BYTE2;
                out_bytes[15:8] <= in;
                byte_count <= byte_count + 1;
            end
            BYTE2: begin
                next_state <= BYTE3;
                out_bytes[7:0] <= in;
                byte_count <= byte_count + 1;
            end
            BYTE3: begin
                done <= 1;
                next_state <= IDLE;
            end
        endcase
    end

    always_ff @(negedge clk) begin
        if (current_state == BYTE3) begin
            done <= 0; // Clear done after asserting once
        end
    end

endmodule