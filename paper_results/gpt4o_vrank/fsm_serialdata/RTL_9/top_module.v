module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE = 3'b000,
        START = 3'b001,
        DATA = 3'b010,
        STOP = 3'b011,
        DONE = 3'b100
    } state_t;
    
    state_t state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_buffer;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_buffer <= 8'b0;
            bit_count <= 3'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                DATA: begin
                    data_buffer <= {in, data_buffer[7:1]};
                    bit_count <= bit_count + 1;
                end
                DONE: begin
                    out_byte <= data_buffer;
                    done <= 1'b1;
                end
                default: done <= 1'b0;
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
            end
            START: begin
                next_state = DATA;
                bit_count = 3'b0; // Reset bit counter on start bit detection
            end
            DATA: begin
                if (bit_count == 3'b111) // After 8 bits
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = DONE;
                else
                    next_state = IDLE; // Error in stop bit, resuming to IDLE
            end
            DONE: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule