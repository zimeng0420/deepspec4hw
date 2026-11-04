module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BYTE1_RECEIVED = 2'b01,
        BYTE2_RECEIVED = 2'b10,
        BYTE3_RECEIVED = 2'b11
    } state_t;
    
    state_t current_state, next_state;
    integer byte_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            out_bytes <= 24'b0;
            done <= 1'b0;
            byte_count <= 0;
        end else begin
            current_state <= next_state;

            if (next_state == BYTE3_RECEIVED) begin
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (next_state == BYTE1_RECEIVED) begin
            out_bytes[23:16] <= in;
        end else if (next_state == BYTE2_RECEIVED) begin
            out_bytes[15:8] <= in;
        end else if (next_state == BYTE3_RECEIVED) begin
            out_bytes[7:0] <= in;
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (in[3] == 1) begin
                    next_state = BYTE1_RECEIVED;
                    byte_count = 1;
                end
            end
            
            BYTE1_RECEIVED: begin
                next_state = BYTE2_RECEIVED;
                byte_count = 2;
            end
            
            BYTE2_RECEIVED: begin
                next_state = BYTE3_RECEIVED;
                byte_count = 3;
            end
            
            BYTE3_RECEIVED: begin
                next_state = BYTE1_RECEIVED; // Loop back for next message
                byte_count = 1; // Reset byte counter for next message
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule