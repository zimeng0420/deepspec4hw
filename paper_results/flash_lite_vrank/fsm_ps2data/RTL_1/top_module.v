module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output [23:0] out_bytes,
	output done
);

    // Define states for the FSM
    localparam IDLE = 0;
    localparam RECEIVE_1 = 1;
    localparam RECEIVE_2 = 2;
    localparam RECEIVE_3 = 3;

    // State register
    reg [1:0] state;

    // Output registers
    reg [23:0] out_bytes_reg;
    reg done_reg;

    // Internal registers
    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [7:0] byte3;


    // FSM logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            out_bytes_reg <= 24'b0;
            done_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done_reg <= 0;
                    if (in[3]) begin
                        byte1 <= in;
                        state <= RECEIVE_1;
                    end
                end
                RECEIVE_1: begin
                    byte2 <= in;
                    state <= RECEIVE_2;
                end
                RECEIVE_2: begin
                    byte3 <= in;
                    out_bytes_reg <= {byte1, byte2, byte3};
                    done_reg <= 1;
                    state <= RECEIVE_3;
                end
                RECEIVE_3: begin
                    done_reg <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end

    // Assign outputs
    assign out_bytes = out_bytes_reg;
    assign done = done_reg;

endmodule