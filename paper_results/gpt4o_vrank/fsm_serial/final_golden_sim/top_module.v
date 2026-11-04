module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE = 3'd0,
        START_BIT = 3'd1,
        DATA_BITS = 3'd2,
        STOP_BIT = 3'd3,
        ERROR = 3'd4
    } state_t;

    reg [2:0] current_state, next_state;
    reg [3:0] bit_counter;  // To count up to 8 data bits
    reg [7:0] data;         // To hold received data bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            bit_counter <= 4'd0;
            done <= 1'b0;
        end else begin
            current_state <= next_state;
            if (current_state == DATA_BITS) begin
                data[bit_counter] <= in;
                bit_counter <= bit_counter + 1;
            end else if (current_state != DATA_BITS) begin
                bit_counter <= 4'd0;
            end
            
            if (current_state == STOP_BIT && in == 1'b1) begin
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (in == 1'b0) begin  // Detect start bit
                    next_state = START_BIT;
                end
            end
            START_BIT: begin
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                if (bit_counter == 4'd8) begin
                    next_state = STOP_BIT;
                end
            end
            STOP_BIT: begin
                if (in == 1'b1) begin  // Correct stop bit
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;  // Wrong stop bit
                end
            end
            ERROR: begin
                if (in == 1'b1) begin  // Wait for next stop bit
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule