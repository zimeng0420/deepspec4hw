module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);
    typedef enum reg [1:0] {IDLE, WAIT_FOR_FIRST, RECEIVE} state_t;
    state_t current_state, next_state;
    reg [1:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            out_bytes <= 24'b0;
            done <= 0;
            byte_count <= 2'b0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        done = 0;

        case (current_state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    next_state = WAIT_FOR_FIRST;
                    byte_count = 2'b0; 
                end
            end
            
            WAIT_FOR_FIRST: begin
                out_bytes[23:16] = in;
                byte_count = 2'b01;
                next_state = RECEIVE;
            end
            
            RECEIVE: begin
                if (byte_count < 2'b10) begin
                    out_bytes <= {out_bytes[15:0], in}; // Shift in new byte
                    byte_count = byte_count + 1;
                end else begin
                    out_bytes <= {out_bytes[15:0], in}; // Shift in new byte
                    done = 1'b1; // Signal done after third byte
                    next_state = IDLE; // Go back to IDLE state
                end
            end

            default: next_state = IDLE;
        endcase
    end
endmodule