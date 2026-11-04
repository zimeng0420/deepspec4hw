module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t current_state, next_state;
    logic [2:0] bit_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            out_byte <= 8'b0;
            bit_count <= 3'b0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (current_state == DATA) begin
            out_byte[bit_count] <= in;
        end
    end

    always_comb begin
        next_state = current_state;

        case (current_state)
            IDLE: begin
                done = 0;
                if (in == 0) begin // start bit detected
                    next_state = START;
                    bit_count = 3'b0;
                end
            end
            START: begin
                if (bit_count == 3'b0) begin // Wait for 1 clock cycle
                    next_state = DATA;
                end
            end
            DATA: begin
                bit_count = bit_count + 1;
                if (bit_count == 3'b111) begin // 8 data bits received
                    next_state = STOP;
                end
            end
            STOP: begin
                if (in == 1) begin // stop bit detected
                    done = 1;
                    next_state = IDLE;
                end else begin
                    next_state = IDLE; // wait for a stop bit
                end
            end
        endcase
    end

endmodule