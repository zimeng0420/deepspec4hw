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
        DATA = 3'b010,
        STOP = 3'b011,
        ERROR = 3'b100
    } state_t;

    state_t state, next_state;
    reg [3:0] bit_counter;
    reg [7:0] shift_register;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 0;
            shift_register <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    if (!in) begin  // Detect start bit
                        next_state <= START;
                    end
                end

                START: begin
                    next_state <= DATA;
                    bit_counter <= 0;
                end

                DATA: begin
                    shift_register <= {in, shift_register[7:1]};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 7) begin
                        next_state <= STOP;
                    end
                end

                STOP: begin
                    if (in) begin  // Detect stop bit
                        out_byte <= shift_register;
                        done <= 1;
                        next_state <= IDLE;
                    end else begin
                        next_state <= ERROR;
                    end
                end

                ERROR: begin
                    if (in) begin  // Wait for line to be idle
                        next_state <= IDLE;
                    end
                end

                default: next_state <= IDLE;
            endcase
        end
    end

    // Reset done signal after a cycle
    always @(posedge clk) begin
        if (state == STOP && in) begin
            done <= 0;
        end
    end

endmodule