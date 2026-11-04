module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum logic [2:0] {
        IDLE,
        START_BIT,
        DATA_BITS,
        STOP_BIT,
        DONE
    } state_t;

    state_t current_state, next_state;
    reg [3:0] bit_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            out_byte <= 8'b0;
            done <= 1'b0;
            bit_count <= 4'b0;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        next_state = current_state;
        done = 1'b0;
        case (current_state)
            IDLE: begin
                if (in == 1'b0) begin // Detect start bit
                    next_state = START_BIT;
                end
            end
            START_BIT: begin
                if (in == 1'b0) begin
                    next_state = DATA_BITS;
                    bit_count = 4'b0;
                end
            end
            DATA_BITS: begin
                if (bit_count < 8) begin
                    out_byte[bit_count] = in; // Capture the data bit
                    bit_count = bit_count + 1;
                end
                if (bit_count == 8) begin
                    next_state = STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in == 1'b1) begin // Check stop bit
                    done = 1'b1;
                    next_state = DONE;
                end
            end
            DONE: begin
                next_state = IDLE; // Return to IDLE after processing
            end
        endcase
    end
endmodule