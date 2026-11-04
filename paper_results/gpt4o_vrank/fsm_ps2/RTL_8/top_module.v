module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output done
);

    reg [1:0] state, next_state;

    // State encoding
    localparam WAIT    = 2'b00;
    localparam BYTE1   = 2'b01;
    localparam BYTE2   = 2'b10;
    localparam BYTE3   = 2'b11;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            WAIT: begin
                if (in[3] == 1'b1)
                    next_state = BYTE1;
                else
                    next_state = WAIT;
            end
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = WAIT;
            default: next_state = WAIT;
        endcase
    end

    // State flip-flops (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= WAIT;
        else
            state <= next_state;
    end

    // Output logic
    assign done = (state == BYTE3);

endmodule