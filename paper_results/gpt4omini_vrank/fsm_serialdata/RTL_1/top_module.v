module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t current_state, next_state;
    reg [2:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            out_byte <= 8'b0;
            done <= 1'b0;
            bit_count <= 3'b0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        done = 1'b0;
        case (current_state)
            IDLE: begin
                if (in == 1'b0) begin  // Start bit detected
                    next_state = START;
                end
            end
            
            START: begin
                next_state = DATA;
                bit_count = 3'b0;
            end
            
            DATA: begin
                if (bit_count < 3'd7) begin
                    out_byte[bit_count] = in;  // Receive data bit
                    bit_count = bit_count + 1;
                end else if (bit_count == 3'd7) begin
                    out_byte[bit_count] = in;  // Receive last data bit
                    next_state = STOP;
                    bit_count = 3'b0;
                end
            end
            
            STOP: begin
                if (in == 1'b1) begin  // Stop bit detected
                    done = 1'b1;
                    next_state = IDLE;  // Go back to IDLE
                end else begin
                    next_state = IDLE;  // Go back to IDLE if not received
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule