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
    
    reg [1:0] state;
    reg [1:0] next_state;
    
    // Message bytes
    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [7:0] byte3;
    
    // Output
    reg [23:0] out_bytes_reg;
    reg done_reg;
    
    // Next State Logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1_RECEIVED;
                end else begin
                    next_state = IDLE;
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
            end
            default: next_state = IDLE;
        endcase
    end

    // State Register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Datapath Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            out_bytes_reg <= 24'b0;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done_reg <= 1'b0;
                end
                BYTE1_RECEIVED: begin
                    byte1 <= in;
                    done_reg <= 1'b0;
                end
                BYTE2_RECEIVED: begin
                    byte2 <= in;
                    done_reg <= 1'b0;
                end
                BYTE3_RECEIVED: begin
                    byte3 <= in;
                    out_bytes_reg <= {byte1, byte2, byte3};
                    done_reg <= 1'b1;
                end
                default: begin
                    done_reg <= 1'b0;
                end
            endcase
        end
    end
    
    assign out_bytes = out_bytes_reg;
    assign done = done_reg;

endmodule