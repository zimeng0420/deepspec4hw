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
    reg [1:0] byte_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            byte_count <= 2'b00;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            current_state <= next_state;
            if (next_state == BYTE1 || next_state == BYTE2 || next_state == BYTE3) 
                out_bytes <= {out_bytes[15:0], in}; 
            if (next_state == BYTE3)
                done <= 1'b1;
            else
                done <= 1'b0;
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    next_state = BYTE1;
                    byte_count = 2'b01;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
                byte_count = 2'b10;
            end
            BYTE2: begin
                next_state = BYTE3;
                byte_count = 2'b11;
            end
            BYTE3: begin
                next_state = IDLE;
            end
        endcase

        // Reset byte count if moving to IDLE
        if (next_state == IDLE)
            byte_count = 0;
    end

endmodule