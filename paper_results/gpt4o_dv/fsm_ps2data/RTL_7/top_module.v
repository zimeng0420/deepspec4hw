module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    // Define state encoding
    parameter IDLE = 2'b00, 
              BYTE1 = 2'b01, 
              BYTE2 = 2'b10, 
              BYTE3 = 2'b11;

    reg [1:0] current_state, next_state;
    reg [23:0] byte_buffer;

    // State Transition Logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                done = 0;
                if (in[3] == 1) begin
                    next_state = BYTE1; 
                end else begin
                    next_state = IDLE;
                end
            end

            BYTE1: begin
                done = 0;
                next_state = BYTE2;
            end

            BYTE2: begin
                done = 0;
                next_state = BYTE3;
            end

            BYTE3: begin
                done = 1;
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Output Logic
    always @(posedge clk) begin
        if (reset) begin
            byte_buffer <= 24'b0;
            out_bytes <= 24'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    // Do nothing
                end
                BYTE1: begin
                    byte_buffer[23:16] <= in;
                end
                BYTE2: begin
                    byte_buffer[15:8] <= in;
                end
                BYTE3: begin
                    byte_buffer[7:0] <= in;
                    out_bytes <= {byte_buffer[23:8], in};
                end
                default: begin
                    // Do nothing
                end
            endcase
        end
    end
endmodule