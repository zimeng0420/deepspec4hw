module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output [23:0] out_bytes,
    output done
);

    // Define states
    localparam IDLE = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    localparam BYTE3 = 2'b11;

    // State register
    reg [1:0] current_state;
    reg [1:0] next_state;

    // Data registers
    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [7:0] byte3;

    // Output register
    reg done_reg;
    reg [23:0] out_bytes_reg;

    // Combinational logic for next state
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state and data registers
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            done_reg <= 1'b0;
            out_bytes_reg <= 24'b0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        done_reg <= 1'b0;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                    done_reg <= 1'b0;
                end
                BYTE2: begin
                    byte3 <= in;
                    done_reg <= 1'b0;
                end
                BYTE3: begin
                    done_reg <= 1'b1;
                    out_bytes_reg <= {byte1, byte2, byte3};
                end
                default: begin
                    done_reg <= 1'b0;
                end
            endcase
        end
    end

    // Output assignments
    assign out_bytes = out_bytes_reg;
    assign done = done_reg;

endmodule