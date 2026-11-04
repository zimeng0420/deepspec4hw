module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output [23:0] out_bytes,
	output done
);
    parameter IDLE = 0, READ1 = 1, READ2 = 2, READ3 = 3;
    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2, byte3;
    reg [23:0] out_bytes_reg;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 0;
        end else begin
            state <= next_state;
            done_reg <= 0; // default
        end
    end

    always @(*) begin
        next_state = state;
        out_bytes_reg = out_bytes_reg; // default, keep previous value
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = READ1;
                end
            end
            READ1: begin
                next_state = READ2;
            end
            READ2: begin
                next_state = READ3;
            end
            READ3: begin
                next_state = IDLE;
                done_reg = 1;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            byte1 <= 0;
            byte2 <= 0;
            byte3 <= 0;
        end else begin
            case (state)
                READ1: begin
                    byte1 <= in;
                end
                READ2: begin
                    byte2 <= in;
                end
                READ3: begin
                    byte3 <= in;
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            out_bytes_reg <= 0;
        end else begin
            case (state)
                READ3: begin
                    out_bytes_reg <= {byte3, byte2, byte1};
                end
            endcase
        end
    end

    assign out_bytes = out_bytes_reg;
    assign done = done_reg;

endmodule