module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State definitions
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

    // State transition and logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 3'd0;
            shift_register <= 8'd0;
            done <= 1'b0;
        end
        else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (!in) begin // Start bit detected (logic 0)
                        next_state <= START;
                    end
                end
                
                START: begin
                    next_state <= DATA;
                    bit_counter <= 3'd0;
                    shift_register <= 8'd0;
                end
                
                DATA: begin
                    shift_register <= {in, shift_register[7:1]};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 3'd7) begin
                        next_state <= STOP;
                    end
                end
                
                STOP: begin
                    if (in) begin // Check for stop bit (logic 1)
                        out_byte <= shift_register;
                        done <= 1'b1;
                        next_state <= IDLE;
                    end
                    else begin
                        next_state <= ERROR;
                    end
                end
                
                ERROR: begin
                    if (in) begin // Wait for line to return to logic 1 before restarting
                        next_state <= IDLE;
                    end
                end
                
                default: begin
                    next_state <= IDLE;
                end
            endcase
        end
    end

    // Combinational logic for next state
    always @(*) begin
        // Default next_state is the current state
        next_state = state;
        
        case (state)
            IDLE: if (!in) next_state = START;
            STOP: if (!in) next_state = ERROR;
            ERROR: if (in) next_state = IDLE;
            default: ;
        endcase
    end

endmodule