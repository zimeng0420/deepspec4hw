module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    reg [3:0] state, next_state;
    reg [2:0] bit_count;

    localparam IDLE = 4'd0,
               START = 4'd1,
               DATA = 4'd2,
               STOP = 4'd3,
               ERROR = 4'd4;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b000;
        end else begin
            state <= next_state;
        end
    end

    always @(posedge clk) begin
        if (state == DATA) begin
            bit_count <= bit_count + 1'b1;
        end else if (state == IDLE || state == STOP || state == ERROR) begin
            bit_count <= 3'b000;
        end
    end

    always @(*) begin
        done = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                if (in == 1'b0) // Start bit detected
                    next_state = START;
            end

            START: begin
                next_state = DATA;
            end

            DATA: begin
                if (bit_count == 3'd7) // 8 data bits received
                    next_state = STOP;
            end

            STOP: begin
                if (in == 1'b1) begin // Valid stop bit
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end

            ERROR: begin
                if (in == 1'b1) // Wait for stop bit before resetting
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule