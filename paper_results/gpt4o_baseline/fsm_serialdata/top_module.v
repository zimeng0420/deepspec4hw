module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum logic [2:0] {
        IDLE = 3'b000,
        START = 3'b001,
        RECEIVE = 3'b010,
        STOP = 3'b011,
        ERROR = 3'b100
    } state_t;

    state_t current_state, next_state;
    reg [2:0] bit_counter;
    reg [7:0] shift_register;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            bit_counter <= 0;
            shift_register <= 8'b0;
            done <= 0;
            out_byte <= 8'b0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
                    done <= 0;
                    if (in == 0) // Start bit detected
                        next_state <= START;
                end
                //! continue....
endmodule
....@END