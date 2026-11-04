module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // State encoding
    localparam IDLE = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    localparam DONE  = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        done = 0;
        next_state = state;
        
        case (state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE1;
            end
            
            BYTE1: begin
                next_state = BYTE2;
            end
            
            BYTE2: begin
                next_state = DONE;
            end
            
            DONE: begin
                done = 1;
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            out_bytes <= 24'b0;
        end else begin
            case (state)
                BYTE1: byte1 <= in;
                BYTE2: byte2 <= in;
                DONE: begin
                    byte3 <= in;
                    out_bytes <= {byte1, byte2, byte3};
                end
            endcase
        end
    end

endmodule