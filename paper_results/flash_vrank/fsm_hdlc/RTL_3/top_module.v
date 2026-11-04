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
    localparam S_RESET = 4'b0000;
    localparam S_0     = 4'b0001;
    localparam S_1     = 4'b0010;
    localparam S_11    = 4'b0011;
    localparam S_111   = 4'b0100;
    localparam S_1111  = 4'b0101;
    localparam S_11111 = 4'b0110;
    localparam S_111110= 4'b0111;
    localparam S_111111= 4'b1000;
    localparam S_1111110= 4'b1001;
    localparam S_ERROR = 4'b1010;
    localparam S_DISCARD= 4'b1011;
    localparam S_FLAG= 4'b1100;


    always @(posedge clk) begin
        if (reset) begin
            state <= S_RESET;
            disc_r <= 1'b0;
            flag_r <= 1'b0;
            err_r <= 1'b0;
        end else begin
            disc_r <= 1'b0;
            flag_r <= 1'b0;
            err_r <= 1'b0;

            case (state)
                S_RESET: begin
                    if (in == 1'b0) state <= S_0;
                    else state <= S_1;
                end
                S_0: begin
                    if (in == 1'b0) state <= S_0;
                    else state <= S_1;
                end
                S_1: begin
                    if (in == 1'b0) state <= S_0;
                    else state <= S_11;
                end
                S_11: begin
                    if (in == 1'b0) state <= S_0;
                    else state <= S_111;
                end
                S_111: begin
                    if (in == 1'b0) state <= S_0;
                    else state <= S_1111;
                end
                S_1111: begin
                    if (in == 1'b0) state <= S_0;
                    else state <= S_11111;
                end
                S_11111: begin
                    if (in == 1'b0) begin
                        state <= S_111110;
                    end else begin
                        state <= S_111111;
                    end
                end
                S_111110: begin
                    state <= S_0;
                    disc_r <= 1'b1;
                    if (in == 1'b0) state <= S_0;
                    else state <=S_1;
                end
                S_111111: begin
                    if (in == 1'b0) begin
                        state <= S_1111110;
                    end else begin
                        state <= S_ERROR;
                    end
                end
                S_1111110: begin
                    state <= S_0;
                    flag_r <= 1'b1;
                    if (in == 1'b0) state <= S_0;
                    else state <= S_1;
                end
                S_ERROR: begin
                     err_r <= 1'b1;
                      if (in == 1'b0) state <= S_0;
                      else state <= S_ERROR;

                end
                default: state <= S_RESET;
            endcase
        end
    end

    assign disc = disc_r;
    assign flag = flag_r;
    assign err = err_r;

endmodule