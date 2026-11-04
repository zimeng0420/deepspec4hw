module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    // State encoding
    localparam IDLE          = 2'b00;
    localparam RECEIVE_BYTE1 = 2'b01;
    localparam RECEIVE_BYTE2 = 2'b10;
    localparam RECEIVE_BYTE3 = 2'b11;

    reg [1:0] state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) 
                    next_state = RECEIVE_BYTE1;
                else 
                    next_state = IDLE;
                done = 0; // done is low in IDLE
            end

            RECEIVE_BYTE1: begin
                if (in[3] == 1'b0) 
                    next_state = RECEIVE_BYTE2;
                else 
                    next_state = RECEIVE_BYTE1;
                done = 0; // done remains low
            end

            RECEIVE_BYTE2: begin
                if (in[3] == 1'b0) 
                    next_state = RECEIVE_BYTE3;
                else 
                    next_state = RECEIVE_BYTE2;
                done = 0; // done remains low
            end

            RECEIVE_BYTE3: begin
                next_state = IDLE; // Transition back to IDLE
                done = 1; // Signal that message is complete
            end

            default: begin
                next_state = IDLE; // Default case
                done = 0; // done is low
            end
        endcase
    end

endmodule