module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE = 3'b000,
        START_BIT = 3'b001,
        DATA_BITS = 3'b010,
        STOP_BIT = 3'b011,
        ERROR = 3'b100
    } state_t;

    reg [2:0] current_state, next_state;
    reg [7:0] shift_reg;
    reg [3:0] bit_count;

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (in == 0)
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end
            START_BIT: begin
                next_state = DATA_BITS;
            end
            DATA_BITS: begin
                if (bit_count == 8)
                    next_state = STOP_BIT;
                else
                    next_state = DATA_BITS;
            end
            STOP_BIT: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            ERROR: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Counter and shift register logic
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 0;
            shift_reg <= 8'b0;
            done <= 0;
        end
        else begin
            case (current_state)
                IDLE: begin
                    done <= 0;
                    bit_count <= 0;
                end
                START_BIT: begin
                    bit_count <= 0;
                end
                DATA_BITS: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP_BIT: begin
                    if (in == 1)
                        done <= 1;
                end
                ERROR: begin
                    done <= 0;
                end
            endcase
        end
    end

endmodule