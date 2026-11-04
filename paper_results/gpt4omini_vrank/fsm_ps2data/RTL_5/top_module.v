module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        FIRST_BYTE = 2'b01,
        SECOND_BYTE = 2'b10,
        THIRD_BYTE = 2'b11
    } state_t;

    state_t state, next_state;
    reg [7:0] byte_count;

    always_ff @(posedge clk) begin
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
        if (state == FIRST_BYTE) begin
            byte_count <= byte_count + 1;
            out_bytes[23:16] <= in;
        end else if (state == SECOND_BYTE) begin
            byte_count <= byte_count + 1;
            out_bytes[15:8] <= in;
        end else if (state == THIRD_BYTE) begin
            byte_count <= byte_count + 1;
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
                    next_state = FIRST_BYTE;
                end
            end
            FIRST_BYTE: begin
                if (byte_count == 0) begin
                    next_state = SECOND_BYTE;
                end
            end
            SECOND_BYTE: begin
                if (byte_count == 1) begin
                    next_state = THIRD_BYTE;
                end
            end
            THIRD_BYTE: begin
                if (byte_count == 2) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule