module top_module (
	input clk,
	input reset,
	input in,
	output disc,
	output flag,
	output err
);

    parameter IDLE = 0,
              S1 = 1,
              S11 = 2,
              S111 = 3,
              S1111 = 4,
              S11111 = 5,
              S111110 = 6,
              S111111 = 7,
              ERROR = 8;

    reg [3:0] state, next_state;
    reg [2:0] ones_count;

    // Output registers
    reg disc_reg, flag_reg, err_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            ones_count <= 3'b0; // Initialize ones_count
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
        end else begin
            state <= next_state;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = IDLE;
        case (state)
            IDLE: begin
                ones_count = 3'b0;
                if (in) begin
                    next_state = S1;
                    ones_count = ones_count + 1;
                end
            end
            S1: begin
                if (in) begin
                    next_state = S11;
                    ones_count = ones_count + 1;
                end else begin
                    next_state = IDLE;
                    ones_count = 3'b0;
                end
            end
            S11: begin
                if (in) begin
                    next_state = S111;
                    ones_count = ones_count + 1;
                end else begin
                    next_state = IDLE;
                    ones_count = 3'b0;
                end
            end
            S111: begin
                if (in) begin
                    next_state = S1111;
                    ones_count = ones_count + 1;
                end else begin
                    next_state = IDLE;
                    ones_count = 3'b0;
                end
            end
            S1111: begin
                if (in) begin
                    next_state = S11111;
                    ones_count = ones_count + 1;
                end else begin
                    next_state = IDLE;
                    ones_count = 3'b0;
                end
            end
            S11111: begin
                if (in) begin
                    next_state = S111111;
                    ones_count = ones_count + 1;
                end else begin
                    next_state = S111110;
                    disc_reg = 1'b1;
                    ones_count = 3'b0;
                end
            end
            S111110: begin
                next_state = IDLE;
                ones_count = 3'b0;
            end
            S111111: begin
                if (in) begin
                    next_state = ERROR;
                    ones_count = ones_count + 1;
                end else begin
                    next_state = IDLE;
                    flag_reg = 1'b1;
                    ones_count = 3'b0;
                end
            end
            ERROR: begin
                next_state = ERROR;
                err_reg = 1'b1;
                ones_count = 3'b0;
            end
            default: next_state = IDLE;
        endcase
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule