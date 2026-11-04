module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    // Define state encodings
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BYTE_1 = 2'b01,
        BYTE_2 = 2'b10,
        BYTE_3 = 2'b11
    } state_t;

    state_t state, next_state;
    reg [1:0] byte_count;

    // State transition logic
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 2'b00;
        end
        else begin
            state <= next_state;
            if (state == BYTE_1 || state == BYTE_2 || state == BYTE_3) begin
                byte_count <= byte_count + 1;
            end
            else begin
                byte_count <= 2'b00;
            end
        end
    end

    // Next state and output logic
    always_comb begin
        done = 1'b0; // Default done output
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE_1;
                end
                else begin
                    next_state = IDLE;
                end
            end
            BYTE_1: begin
                next_state = BYTE_2;
            end
            BYTE_2: begin
                next_state = BYTE_3;
            end
            BYTE_3: begin
                done = 1'b1; // Signal done on the completion of the third byte
                if (in[3]) begin
                    next_state = BYTE_1; // Start of a new message
                end
                else begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule