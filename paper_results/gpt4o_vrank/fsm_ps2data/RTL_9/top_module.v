module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state, next_state;
    reg [23:0] message;
    
    // State encoding
    localparam WAIT    = 2'd0;
    localparam BYTE1   = 2'd1;
    localparam BYTE2   = 2'd2;
    localparam BYTE3   = 2'd3;

    // State transition logic
    always @(*) begin
        case (state)
            WAIT:   next_state = in[3] ? BYTE1 : WAIT;
            BYTE1:  next_state = BYTE2;
            BYTE2:  next_state = BYTE3;
            BYTE3:  next_state = in[3] ? BYTE1 : WAIT;
            default: next_state = WAIT;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= WAIT;
        else
            state <= next_state;
    end

    // Output logic and message assembly
    always @(posedge clk) begin
        if (reset) begin
            message <= 24'b0;
            done <= 1'b0;
            out_bytes <= 24'b0;
        end
        else begin
            done <= 1'b0;
            case (state)
                BYTE1: message[23:16] <= in;
                BYTE2: message[15:8] <= in;
                BYTE3: begin
                    message[7:0] <= in;
                    out_bytes <= {message[23:8], in};
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule