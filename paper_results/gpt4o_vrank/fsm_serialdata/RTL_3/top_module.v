module top_module (
	input clk,
	input in,
	input reset,
	output reg [7:0] out_byte,
	output reg done
);

    reg [3:0] state, next_state;
    reg [7:0] data_shift;
    reg [2:0] bit_count;
    
    localparam IDLE = 4'd0,
               START = 4'd1,
               DATA = 4'd2,
               STOP = 4'd3,
               ERROR = 4'd4;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                done = 0;
                if (in == 0) // Start bit detected
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: next_state = DATA;
            DATA: begin
                if (bit_count == 7) // Last data bit
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1) // Correct stop bit
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            ERROR: begin
                done = 0;
                if (in == 1) // Wait for idle line
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output and data shift register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_shift <= 8'b0;
            bit_count <= 3'b0;
            out_byte <= 8'b0;
            done <= 0;
        end else begin
            case (state)
                START: begin
                    bit_count <= 3'b0;
                    done <= 0;
                end
                DATA: begin
                    data_shift[bit_count] <= in;
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    if (in == 1) begin
                        out_byte <= data_shift;
                        done <= 1;
                    end else begin
                        done <= 0;
                    end
                end
                ERROR: begin
                    done <= 0;
                end
            endcase
        end
    end

endmodule