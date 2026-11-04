module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        WAIT_FOR_HEADER = 2'b00,
        BYTE_1 = 2'b01,
        BYTE_2 = 2'b10,
        BYTE_3 = 2'b11
    } state_t;

    state_t current_state, next_state;
    reg [7:0] byte_1, byte_2, byte_3;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= WAIT_FOR_HEADER;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic and output logic
    always @(*) begin
        // Defaults
        next_state = current_state;
        done = 0;

        case (current_state)
            WAIT_FOR_HEADER: begin
                if (in[3] == 1) begin
                    next_state = BYTE_1;
                end
            end

            BYTE_1: begin
                byte_1 = in;  // Capture first byte
                next_state = BYTE_2;
            end

            BYTE_2: begin
                byte_2 = in;  // Capture second byte
                next_state = BYTE_3;
            end

            BYTE_3: begin
                byte_3 = in;  // Capture third byte
                done = 1;  // Signal packet complete
                next_state = WAIT_FOR_HEADER;
            end
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 0;
        end else begin
            if (done) begin
                out_bytes <= {byte_1, byte_2, byte_3};
            end
        end
    end

endmodule