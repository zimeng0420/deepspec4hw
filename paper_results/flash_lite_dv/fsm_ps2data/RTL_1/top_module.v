module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output [23:0] out_bytes,
    output done
);

    // State Definition
    localparam IDLE = 2'b00;
    localparam BYTE1_RECEIVED = 2'b01;
    localparam BYTE2_RECEIVED = 2'b10;
    localparam BYTE3_RECEIVED = 2'b11;
    
    // Internal Signals
    reg [1:0] current_state, next_state;
    reg [7:0] byte1, byte2, byte3;
    reg [23:0] out_bytes_reg;
    reg done_reg;
    
    // Byte Counter
    reg [1:0] byte_count;

    // State Transition Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            byte_count <= 2'b00;
            done_reg <= 1'b0;
        end else begin
            current_state <= next_state;
            if (done_reg)
                done_reg <= 1'b0;
        end
    end
    
    // Next State Logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1_RECEIVED;
                    byte_count = 2'b01;
                end else begin
                  next_state = IDLE;
                  byte_count = 2'b00;
                end
            end
            BYTE1_RECEIVED: begin
                next_state = BYTE2_RECEIVED;
                byte_count = 2'b10;
            end
            BYTE2_RECEIVED: begin
                next_state = BYTE3_RECEIVED;
                byte_count = 2'b11;
            end
            BYTE3_RECEIVED: begin
                next_state = IDLE;
                byte_count = 2'b00;
            end
            default: next_state = IDLE;
        endcase
    end
    
    // Output Logic
    always @(posedge clk) begin
        if (reset) begin
            out_bytes_reg <= 24'b0;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            case (current_state)
                BYTE1_RECEIVED: byte1 <= in;
                BYTE2_RECEIVED: byte2 <= in;
                BYTE3_RECEIVED: byte3 <= in;
            endcase
            
            if (current_state == BYTE3_RECEIVED) begin
                out_bytes_reg <= {byte1, byte2, byte3};
                done_reg <= 1'b1;
            end
        end
    end
    
    assign out_bytes = out_bytes_reg;
    assign done = done_reg;
    
endmodule