module top_module (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    reg [2:0] state, next_state;
    reg [3:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;

    localparam IDLE = 3'd0;
    localparam START = 3'd1;
    localparam DATA = 3'd2;
    localparam STOP = 3'd3;
    localparam ERROR = 3'd4;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (!in) 
                    next_state = START;
                else 
                    next_state = IDLE;
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_count < 8) 
                    next_state = DATA;
                else 
                    next_state = STOP;
            end
            STOP: begin
                if (in)
                    next_state = IDLE;
                else 
                    next_state = ERROR;
            end
            ERROR: begin
                if (in)
                    next_state = IDLE;
                else 
                    next_state = ERROR;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output and counter control logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 4'd0;
            shift_reg <= 8'd0;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 4'd0;
                    done_reg <= 1'b0;
                end
                START: begin
                    bit_count <= 4'd0;
                end
                DATA: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    if (in) begin
                        done_reg <= 1'b1;
                    end
                end
                ERROR: begin
                    done_reg <= 1'b0;
                end
            endcase
        end
    end

    assign out_byte = shift_reg;
    assign done = done_reg;

endmodule