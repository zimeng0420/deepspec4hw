module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE       = 2'b00,
        START_BIT  = 2'b01,
        DATA_BITS  = 2'b10,
        STOP_BIT   = 2'b11
    } state_t;

    state_t current_state, next_state;
    logic [3:0] bit_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            out_byte <= 8'b0;
            done <= 1'b0;
            bit_count <= 4'b0;
        end else begin
            current_state <= next_state;
            if (current_state == DATA_BITS) begin
                out_byte <= {in, out_byte[7:1]};
            end
            done <= (next_state == STOP_BIT);
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                done = 1'b0;
                if (in == 1'b0) begin // Start bit detected
                    next_state = START_BIT;
                end
            end

            START_BIT: begin
                if (in == 1'b1) begin // Move to receiving data
                    next_state = DATA_BITS;
                    bit_count = 4'b0;
                end
            end

            DATA_BITS: begin
                if (bit_count < 4'd7) begin
                    bit_count = bit_count + 1;
                    next_state = DATA_BITS;
                end else begin
                    next_state = STOP_BIT; // 8 bits received, expect stop bit
                end
            end

            STOP_BIT: begin
                if (in == 1'b1) begin // Stop bit detected
                    next_state = IDLE; // Return to idle state
                end else begin
                    next_state = STOP_BIT; // Wait for stop bit
                end
            end

        endcase
    end

endmodule