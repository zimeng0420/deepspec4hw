module top_module (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err);

    reg [3:0] state;
    reg disc_r, flag_r, err_r;

    // State definitions
    localparam S_IDLE = 4'b0000;
    localparam S_1 = 4'b0001;
    localparam S_11 = 4'b0010;
    localparam S_111 = 4'b0011;
    localparam S_1111 = 4'b0100;
    localparam S_11111 = 4'b0101;
    localparam S_111110 = 4'b0110;
    localparam S_111111 = 4'b0111;
    localparam S_1111110 = 4'b1000;
    localparam S_1111111 = 4'b1001;
    localparam S_ERROR = 4'b1010;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            disc_r <= 0;
            flag_r <= 0;
            err_r <= 0;
        end else begin
            disc_r <= 0;
            flag_r <= 0;
            err_r <= 0;

            case (state)
                S_IDLE: begin
                    if (in) state <= S_1;
                    else state <= S_IDLE;
                end
                S_1: begin
                    if (in) state <= S_11;
                    else state <= S_IDLE;
                end
                S_11: begin
                    if (in) state <= S_111;
                    else state <= S_IDLE;
                end
                S_111: begin
                    if (in) state <= S_1111;
                    else state <= S_IDLE;
                end
                S_1111: begin
                    if (in) state <= S_11111;
                    else state <= S_IDLE;
                end
                S_11111: begin
                    if (in) state <= S_111111;
                    else state <= S_111110;
                end
                S_111110: begin
                    disc_r <= 1;
                    if (in) state <= S_1;
                    else state <= S_IDLE;
                end
                S_111111: begin
                    if (in) state <= S_1111111;
                    else state <= S_1111110;
                end
                S_1111110: begin
                    flag_r <= 1;
                    if (in) state <= S_1;
                    else state <= S_IDLE;
                end
                S_1111111: begin
                    if (in) state <= S_ERROR;
                    else state <= S_1111110;
                end
                S_ERROR: begin
                    err_r <= 1;
                    if (in) state <= S_ERROR;
                    else state <= S_IDLE;
                end
                default: state <= S_IDLE;
            endcase
        end
    end

    assign disc = disc_r;
    assign flag = flag_r;
    assign err = err_r;

endmodule