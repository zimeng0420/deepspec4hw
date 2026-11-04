module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE          = 3'b000,
        S1            = 3'b001,
        S2            = 3'b010,
        S3            = 3'b011,
        SHIFT         = 3'b100,
        COUNTING      = 3'b101,
        DONE          = 3'b110
    } state_t;

    state_t current_state, next_state;
    reg [1:0] shift_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_counter <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == SHIFT) begin
                if (shift_counter < 4) begin
                    shift_counter <= shift_counter + 1;
                end else begin
                    shift_counter <= 0;
                end
            end
        end
    end

    always @(*) begin
        next_state = current_state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (current_state)
            IDLE: begin
                if (data == 1) begin
                    next_state = S1;
                end
            end

            S1: begin
                if (data == 1) begin
                    next_state = S2;
                end else begin
                    next_state = IDLE;
                end
            end

            S2: begin
                if (data == 0) begin
                    next_state = S3;
                end else begin
                    next_state = IDLE;
                end
            end

            S3: begin
                if (data == 1) begin
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end

            SHIFT: begin
                shift_ena = 1;
                if (shift_counter == 3) begin
                    next_state = COUNTING;
                end
            end

            COUNTING: begin
                counting = 1;
                if (done_counting) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                done = 1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule