module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        START = 3'b001,
        DATA = 3'b010,
        STOP = 3'b011,
        ERROR = 3'b100
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_counter;
    reg [7:0] shift_register;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and data reception
    always @(*) begin
        // Default outputs and next state
        next_state = state;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (~in) begin // Look for start bit (logic 0)
                    next_state = START;
                end
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_counter == 3'b111) begin
                    next_state = STOP;
                end
            end
            STOP: begin
                if (in) begin // Check stop bit (logic 1)
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in) begin // Wait for line to go idle (stop bit logic 1)
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Data reception and output logic
    always @(posedge clk) begin
        if (reset) begin
            bit_counter <= 3'd0;
            shift_register <= 8'd0;
            out_byte <= 8'd0;
        end else begin
            case (state)
                DATA: begin
                    shift_register <= {in, shift_register[7:1]};
                    bit_counter <= bit_counter + 3'd1;
                    if (bit_counter == 3'd7) begin
                        out_byte <= {in, shift_register[7:1]};
                    end
                end
                default: begin
                    bit_counter <= 3'd0;
                end
            endcase
        end
    end

endmodule