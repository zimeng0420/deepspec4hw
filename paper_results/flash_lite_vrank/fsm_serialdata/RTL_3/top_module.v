module top_module (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    parameter IDLE = 0,
              START = 1,
              DATA = 2,
              STOP = 3;

    reg [7:0] data_in;
    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg done_r;


    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done_r <= 0;
        end else begin
            state <= next_state;
            if (state == DATA && bit_count == 7)
                done_r <= 1;
            else
                done_r <= 0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (!in) begin // start bit detected
                    next_state = START;
                    bit_count = 0;
                end
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_count < 7) begin
                    bit_count = bit_count + 1;
                    next_state = DATA;
                end else begin
                    next_state = STOP;
                end
            end
            STOP: begin
                if (in) begin // Stop bit detected, byte received
                    next_state = IDLE;
                end else begin // Stop bit not detected, wait for stop
                    next_state = STOP;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            data_in <= 0;
        end else begin
          if (state == DATA) begin
            data_in[bit_count] <= in;
          end
        end
    end

    assign out_byte = data_in;
    assign done = done_r;

endmodule