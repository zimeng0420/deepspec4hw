module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE,
        RECEIVING,
        COMPLETE
    } state_t;

    state_t current_state, next_state;
    reg [2:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            byte_count <= 3'b000;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            current_state <= next_state;
            if (next_state == RECEIVING) begin
                byte_count <= byte_count + 1;
                case (byte_count)
                    3'b000: out_bytes[23:16] <= in; // First byte
                    3'b001: out_bytes[15:8] <= in;  // Second byte
                    3'b010: out_bytes[7:0] <= in;   // Third byte
                endcase
            end else if (next_state == COMPLETE) begin
                done <= 1'b1; // Signal done
            end else begin
                done <= 1'b0; // Reset done
            end
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: begin
                if (in[3] == 1) begin
                    next_state = RECEIVING;
                    byte_count = 3'b000;
                end else begin
                    next_state = IDLE;
                end
            end
            RECEIVING: begin
                if (byte_count < 3'b010) begin
                    next_state = RECEIVING;
                end else begin
                    next_state = COMPLETE;
                end
            end
            COMPLETE: begin
                next_state = IDLE; // Go back to IDLE after signaling done
            end
            default: begin
                next_state = IDLE; // Default case
            end
        endcase
    end

endmodule