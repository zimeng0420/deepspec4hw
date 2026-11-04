module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);
    // State encoding
    typedef enum logic [2:0] {
        IDLE       = 3'b000,
        START_BIT  = 3'b001,
        DATA_BITS  = 3'b010,
        STOP_BIT   = 3'b011,
        ERROR      = 3'b100
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;
    reg [7:0] byte_data;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_byte <= 8'b0;
            byte_data <= 8'b0;
            bit_count <= 3'd0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        done = 1'b0;
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) begin // Detect start bit
                    next_state = START_BIT;
                end
            end
            START_BIT: begin
                next_state = DATA_BITS;
                bit_count = 3'b000;
            end
            DATA_BITS: begin
                if (bit_count == 3'd7) begin
                    next_state = STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in == 1'b1) begin // Check stop bit
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_state = ERROR; // Error state if stop bit is invalid
                end
            end
            ERROR: begin
                if (in == 1'b1) begin // Wait for line to be idle
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Output and data bit capture
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'b0;
            byte_data <= 8'b0;
        end else if (state == DATA_BITS) begin
            byte_data[bit_count] <= in;
            out_byte <= byte_data;
            bit_count <= bit_count + 1'b1;
        end
    end
endmodule