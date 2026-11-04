module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    reg [1:0] state, next_state;
    reg [1:0] byte_count;

    localparam IDLE = 2'b00,
               BYTE_1 = 2'b01,
               BYTE_2 = 2'b10,
               BYTE_3 = 2'b11;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 2'b00;
        end else begin
            state <= next_state;
            if (state == BYTE_1 || state == BYTE_2 || state == BYTE_3)
                byte_count <= byte_count + 1;
            else
                byte_count <= 2'b00;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1)
                    next_state = BYTE_1;
                else
                    next_state = IDLE;
            end
            BYTE_1: begin
                next_state = BYTE_2;
            end
            BYTE_2: begin
                next_state = BYTE_3;
            end
            BYTE_3: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Output logic
    always @(*) begin
        done = (state == BYTE_3);
    end

endmodule