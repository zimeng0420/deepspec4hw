module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);
    typedef enum logic [1:0] {
        IDLE,
        WAIT_FOR_FIRST_BYTE,
        RECEIVE_BYTES
    } state_t;

    state_t current_state, next_state;
    reg [1:0] byte_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            byte_count <= 0;
            out_bytes <= 24'b0;
            done <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == RECEIVE_BYTES) begin
                out_bytes <= {out_bytes[15:0], in};
                if (byte_count == 2) begin
                    done <= 1;
                end else begin
                    done <= 0;
                end
            end
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            byte_count <= 0;
        end else if (current_state == RECEIVE_BYTES) begin
            byte_count <= byte_count + 1;
        end else if (current_state == WAIT_FOR_FIRST_BYTE && (in[3] == 1)) begin
            byte_count <= 1;
        end
    end

    always_comb begin
        case (current_state)
            IDLE: begin
                if (in[3] == 1) begin
                    next_state = WAIT_FOR_FIRST_BYTE;
                end else begin
                    next_state = IDLE;
                end
            end
            WAIT_FOR_FIRST_BYTE: begin
                next_state = RECEIVE_BYTES;
            end
            RECEIVE_BYTES: begin
                if (byte_count == 2) begin
                    next_state = IDLE;
                end else begin
                    next_state = RECEIVE_BYTES;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule