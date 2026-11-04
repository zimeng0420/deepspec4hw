module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum reg [1:0] {IDLE=2'b00, BYTE1=2'b01, BYTE2=2'b10, BYTE3=2'b11} state_t;
    state_t state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        // Default values
        next_state = state;
        done = 0;
        out_bytes = 24'bx;

        case (state)
            IDLE: begin
                if (in[3] == 1) begin
                    byte1 = in;
                    next_state = BYTE1;
                end
            end
            BYTE1: begin
                byte2 = in;
                next_state = BYTE2;
            end
            BYTE2: begin
                byte3 = in;
                next_state = BYTE3;
            end
            BYTE3: begin
                out_bytes = {byte1, byte2, byte3};
                done = 1;
                if (in[3] == 1) begin
                    byte1 = in;
                    next_state = BYTE1;
                end else begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Register to store incoming bytes
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            byte1 <= 8'h00;
            byte2 <= 8'h00;
            byte3 <= 8'h00;
        end else if (state == BYTE1) begin
            byte1 <= in;
        end else if (state == BYTE2) begin
            byte2 <= in;
        end else if (state == BYTE3) begin
            byte3 <= in;
        end
    end

endmodule