module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [3:0] state, next_state;
    reg [7:0] data;
    reg [3:0] bit_count;

    // State encoding
    localparam IDLE      = 4'b0000;
    localparam START_BIT = 4'b0001;
    localparam DATA_BITS = 4'b0010;
    localparam STOP_BIT  = 4'b0011;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        done = 0;

        case (state)
            IDLE: begin
                if (in == 1'b0)  // Detect start bit
                    next_state = START_BIT;
            end
            START_BIT: begin
                next_state = DATA_BITS;
                bit_count = 0;
            end
            DATA_BITS: begin
                if (bit_count < 8)
                    next_state = DATA_BITS;
                else
                    next_state = STOP_BIT;
            end
            STOP_BIT: begin
                if (in == 1'b1) begin  // Detect stop bit
                    done = 1;
                    next_state = IDLE;
                end else begin
                    next_state = IDLE;  // Wait for a valid stop bit
                end
            end
        endcase
    end

    // Output and counter logic
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'b0;
            data <= 8'b0;
            bit_count <= 4'b0;
        end else begin
            case (state)
                DATA_BITS: begin
                    data[bit_count] <= in;  // Shift in LSB first
                    bit_count <= bit_count + 1;
                    if (bit_count == 7)
                        out_byte <= {in, data[7:1]};  // Capture the full byte on the last data bit
                end
                STOP_BIT: begin
                    if (in)  // Stop bit is correct, load data to output
                        out_byte <= data;
                end
            endcase
        end
    end

endmodule