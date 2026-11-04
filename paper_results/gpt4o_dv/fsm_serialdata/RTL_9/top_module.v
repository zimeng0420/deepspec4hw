module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State declarations
    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP,
        ERROR
    } state_t;

    // State variables
    state_t state, next_state;
    reg [2:0] bit_counter;
    reg [7:0] shift_register;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 3'b0;
            shift_register <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            if (state == DATA) begin
                shift_register <= {in, shift_register[7:1]};
                bit_counter <= bit_counter + 1'b1;
            end

            if (state == STOP && in == 1'b1) begin
                out_byte <= shift_register;
            end

            done <= (state == STOP && in == 1'b1);
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (in == 1'b0) ? START : IDLE;
            START: next_state = DATA;
            DATA: next_state = (bit_counter == 3'b111) ? STOP : DATA;
            STOP: next_state = (in == 1'b1) ? IDLE : ERROR;
            ERROR: next_state = (in == 1'b1) ? IDLE : ERROR;
            default: next_state = IDLE;
        endcase
    end

endmodule