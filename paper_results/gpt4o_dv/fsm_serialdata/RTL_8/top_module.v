module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Define state encoding
    typedef enum logic [2:0] {
        IDLE    = 3'b000,
        START   = 3'b001,
        DATA    = 3'b010,
        STOP    = 3'b011,
        ERROR   = 3'b100
    } state_t;
    
    // State, bit counter and shift register
    state_t state, next_state;
    reg [2:0] bit_counter;
    reg [7:0] shift_register;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 3'b0;
            shift_register <= 8'b0;
            done <= 1'b0;
        end
        else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in == 1'b0) begin
                        next_state <= START;
                    end
                end
                START: begin
                    if (in == 1'b0) begin
                        next_state <= DATA;
                        bit_counter <= 3'b0;
                    end
                    else begin
                        next_state <= IDLE;
                    end
                end
                DATA: begin
                    shift_register[bit_counter] <= in;
                    bit_counter <= bit_counter + 1;

                    if (bit_counter == 3'b111) begin
                        next_state <= STOP;
                    end
                end
                STOP: begin
                    if (in == 1'b1) begin
                        next_state <= IDLE;
                        done <= 1'b1;
                        out_byte <= shift_register;
                    end
                    else begin
                        next_state <= ERROR;
                    end
                end
                ERROR: begin
                    if (in == 1'b1) begin
                        next_state <= IDLE;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;

        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = START;
                end
            end
            START: begin
                if (in == 1'b0) begin
                    next_state = DATA;
                end
                else begin
                    next_state = IDLE;
                end
            end
            DATA: begin
                if (bit_counter == 3'b111) begin
                    next_state = STOP;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule