module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [3:0] state, next_state;
    reg [7:0] data;
    reg [2:0] bit_count;
    
    // State encoding
    localparam IDLE       = 4'd0;
    localparam START_BIT  = 4'd1;
    localparam DATA_BITS  = 4'd2;
    localparam STOP_BIT   = 4'd3;

    // State transitions
    always @(*) begin
        case (state)
            IDLE: begin
                if (!in) // Detect start bit (0)
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end
            START_BIT: begin
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                if (bit_count == 3'd7)
                    next_state = STOP_BIT;
                else
                    next_state = DATA_BITS;
            end
            STOP_BIT: begin
                if (in) // Detect stop bit (1)
                    next_state = IDLE;
                else
                    next_state = STOP_BIT; // Remain in stop until we see a 1
            end
            default: next_state = IDLE;
        endcase
    end

    // State register and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_byte <= 8'd0;
            done <= 0;
            bit_count <= 3'd0;
            data <= 8'd0;
        end else begin
            state <= next_state;
            done <= 0; // Default: done = 0

            case (state)
                START_BIT: begin
                    bit_count <= 3'd0;
                end
                DATA_BITS: begin
                    data[bit_count] <= in;
                    bit_count <= bit_count + 1;
                end
                STOP_BIT: begin
                    if (in) begin // Stop bit verification
                        out_byte <= data;
                        done <= 1;
                    end
                end
            endcase
        end
    end
endmodule