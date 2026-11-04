module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output [23:0] out_bytes,
    output done
);

    // States
    parameter IDLE = 2'b00;
    parameter BYTE1_RECEIVED = 2'b01;
    parameter BYTE2_RECEIVED = 2'b10;
    parameter BYTE3_RECEIVED = 2'b11;

    // State register
    reg [1:0] current_state, next_state;

    // Byte registers
    reg [7:0] byte1, byte2, byte3;

    // Output register
    reg [23:0] out_bytes_reg;

    // Done signal
    reg done_reg, done_next;

    // Combinational logic for next state and outputs
    always @(*) begin
        next_state = current_state;
        done_next = 1'b0;
        out_bytes_reg = out_bytes; // default value

        case (current_state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1_RECEIVED;
                end
            end
            BYTE1_RECEIVED: begin
                next_state = BYTE2_RECEIVED;
            end
            BYTE2_RECEIVED: begin
                next_state = BYTE3_RECEIVED;
            end
            BYTE3_RECEIVED: begin
                next_state = IDLE;
                done_next = 1'b1;
            end
            default: next_state = IDLE;
        endcase

        // Generate out_bytes
        if (done_next) begin
            out_bytes_reg = {byte1, byte2, byte3};
        end
    end

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            done_reg <= 1'b0;
        end else begin
            current_state <= next_state;
            done_reg <= done_next;
        end
    end

    // Byte capture logic
    always @(posedge clk) begin
        if (reset) begin
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
        end else begin
            case (current_state)
                BYTE1_RECEIVED: byte1 <= in;
                BYTE2_RECEIVED: byte2 <= in;
                BYTE3_RECEIVED: byte3 <= in;
                default: ;
            endcase
        end
    end

    // Output assignments
    assign out_bytes = out_bytes_reg;
    assign done = done_reg;

endmodule