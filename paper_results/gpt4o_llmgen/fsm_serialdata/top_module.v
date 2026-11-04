module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    typedef enum reg [3:0] {
        IDLE        = 4'd0,
        START       = 4'd1,
        RECEIVE_D0  = 4'd2,
        RECEIVE_D1  = 4'd3,
        RECEIVE_D2  = 4'd4,
        RECEIVE_D3  = 4'd5,
        RECEIVE_D4  = 4'd6,
        RECEIVE_D5  = 4'd7,
        RECEIVE_D6  = 4'd8,
        RECEIVE_D7  = 4'd9,
        STOP        = 4'd10,
        ERROR       = 4'd11
    } state_t;

    state_t state, next_state;
    reg [7:0] data_reg;
    reg bit_received;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            out_byte <= 8'd0;
            done <= 1'b0;
            data_reg <= 8'b0;
        end else begin
            state <= next_state;
            if (bit_received) begin
                data_reg <= {in, data_reg[7:1]};  // Shift the received bit into the register
            end
            if (state == STOP && in == 1'b1) begin
                out_byte <= data_reg;
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    always @(*) begin
        // Default values
        next_state = state;
        bit_received = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0) begin  // Detect start bit
                    next_state = START;
                end
            end

            START: begin
                next_state = RECEIVE_D0;
                bit_received = 1'b1;
            end

            RECEIVE_D0: begin
                next_state = RECEIVE_D1;
                bit_received = 1'b1;
            end

            RECEIVE_D1: begin
                next_state = RECEIVE_D2;
                bit_received = 1'b1;
            end

            RECEIVE_D2: begin
                next_state = RECEIVE_D3;
                bit_received = 1'b1;
            end

            RECEIVE_D3: begin
                next_state = RECEIVE_D4;
                bit_received = 1'b1;
            end

            RECEIVE_D4: begin
                next_state = RECEIVE_D5;
                bit_received = 1'b1;
            end

            RECEIVE_D5: begin
                next_state = RECEIVE_D6;
                bit_received = 1'b1;
            end

            RECEIVE_D6: begin
                next_state = RECEIVE_D7;
                bit_received = 1'b1;
            end

            RECEIVE_D7: begin
                next_state = STOP;
                bit_received = 1'b1;
            end

            STOP: begin
                if (in == 1'b1) begin  // Correct stop bit
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;  // Incorrect stop bit
                end
            end

            ERROR: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;

        endcase
    end
endmodule