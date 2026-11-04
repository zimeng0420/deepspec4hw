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

    state_t state, next_state;
    reg [2:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            out_byte <= 8'b0;
            done <= 0;
            bit_count <= 3'b0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                out_byte[bit_count] <= in;
                bit_count <= bit_count + 1;
            end
            if (state == STOP) begin
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 0) begin
                    next_state = START;
                end else begin
                    next_state = IDLE;
                end
            end
            
            START: begin
                next_state = DATA;
                bit_count = 3'b0; // Reset bit count for data bits
            end
            
            DATA: begin
                if (bit_count == 3'd7) begin
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end
            
            STOP: begin
                if (in == 1) begin
                    next_state = IDLE; // Transition back to IDLE after receiving stop bit
                end else begin
                    next_state = STOP; // Stay in STOP until we see a valid stop bit
                end
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule