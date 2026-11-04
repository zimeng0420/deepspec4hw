module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output done
);

    reg [1:0] state, next_state;

    // State encoding
    localparam IDLE     = 2'b00;
    localparam BYTE1    = 2'b01;
    localparam BYTE2    = 2'b10;
    localparam BYTE3    = 2'b11;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    next_state = BYTE1;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                if (in[3] == 1'b1) begin
                    next_state = BYTE1; // Next possible start of message
                end else begin
                    next_state = IDLE;  // Go to IDLE and await next valid message start
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign done = (state == BYTE3);

endmodule