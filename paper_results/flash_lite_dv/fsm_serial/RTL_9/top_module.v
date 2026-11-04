module top_module (
    input clk,
    input in,
    input reset,
    output done
);

    parameter IDLE      = 3'b000;
    parameter START_BIT = 3'b001;
    parameter DATA_BITS = 3'b010;
    parameter STOP_BIT  = 3'b011;
    parameter ERROR     = 3'b100;

    reg [2:0] state;
    reg [2:0] next_state;
    reg [2:0] data_bit_count;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_bit_count <= 3'b000;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            if (state == STOP_BIT && in == 1'b1) begin
              done_reg <= 1'b1;
            end else begin
              done_reg <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = START_BIT;
                end
            end
            START_BIT: begin
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                if (data_bit_count == 3'b111) begin // 8 bits received
                    next_state = STOP_BIT;
                end else begin
                    next_state = DATA_BITS;
                end
            end
            STOP_BIT: begin
                if (in == 1'b1) begin // stop bit correct
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in == 1'b1) begin //wait for stop bit
                    next_state = IDLE;
                end
            end
            default:
                next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            data_bit_count <= 3'b000;
        end else begin
            if (state == DATA_BITS) begin
                data_bit_count <= data_bit_count + 1;
            end else if (state != DATA_BITS) begin
              data_bit_count <= 3'b000;
            end
        end
    end

    assign done = done_reg;

endmodule