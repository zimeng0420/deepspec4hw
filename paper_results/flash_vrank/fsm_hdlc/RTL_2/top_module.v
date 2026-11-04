module top_module (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err);

    // Define states
    localparam S_IDLE = 0;
    localparam S_1    = 1;
    localparam S_11   = 2;
    localparam S_111  = 3;
    localparam S_1111 = 4;
    localparam S_11111= 5;
    localparam S_111110=6;
    localparam S_111111=7;
    localparam S_ERROR = 8;

    reg [3:0] current_state;
    reg [3:0] next_state;

    reg disc_r;
    reg flag_r;
    reg err_r;

    assign disc = disc_r;
    assign flag = flag_r;
    assign err = err_r;


    // State transition logic
    always @(*) begin
        next_state = S_IDLE;  // Default next state
        case (current_state)
            S_IDLE: begin
                if (in == 1) next_state = S_1;
                else next_state = S_IDLE;
            end
            S_1: begin
                if (in == 1) next_state = S_11;
                else next_state = S_IDLE;
            end
            S_11: begin
                if (in == 1) next_state = S_111;
                else next_state = S_IDLE;
            end
            S_111: begin
                if (in == 1) next_state = S_1111;
                else next_state = S_IDLE;
            end
            S_1111: begin
                if (in == 1) next_state = S_11111;
                else next_state = S_IDLE;
            end
            S_11111: begin
                if (in == 1) next_state = S_111111;
                else next_state = S_111110;
            end
            S_111110: begin
                if (in == 1) next_state = S_1;
                else next_state = S_IDLE;
            end
            S_111111: begin
                if(in == 1) next_state = S_ERROR;
                else next_state = S_IDLE;
            end
            S_ERROR: begin
                next_state = S_ERROR;
            end
            default: next_state = S_IDLE;
        endcase
    end

    // State update logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_IDLE;
            disc_r <= 0;
            flag_r <= 0;
            err_r <= 0;
        end else begin
            current_state <= next_state;
            disc_r <= 0;
            flag_r <= 0;
            err_r <= 0;

            if (current_state == S_111110) begin
                disc_r <= 1;
            end else if (current_state == S_111111 && in == 0) begin
                flag_r <= 1;
            end else if (current_state == S_ERROR) begin
                err_r <= 1;
            end
        end
    end

endmodule