module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    // State definitions
    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    state_t current_state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic and byte capture
    always @(*) begin
        next_state = current_state;
        done = 0;
        case (current_state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE1;
            end
            BYTE1: begin
                byte1 = in;
                next_state = BYTE2;
            end
            BYTE2: begin
                byte2 = in;
                next_state = BYTE3;
            end
            BYTE3: begin
                byte3 = in;
                done = 1;
                next_state = IDLE;
            end
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (done)
            out_bytes <= {byte1, byte2, byte3};
    end

    // Reset logic
    always @(posedge clk) begin
        if (reset) begin
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
        end
    end

endmodule