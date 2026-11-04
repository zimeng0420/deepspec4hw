module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    // State machine states
    typedef enum logic [3:0] {
        IDLE,
        DETECT_1,
        DETECT_2,
        DETECT_3,
        GET_DELAY_0,
        GET_DELAY_1,
        GET_DELAY_2,
        GET_DELAY_3,
        COUNTING,
        DONE
    } state_t;

    reg state;
    reg next_state;

    // Internal signals
    reg [3:0] delay;
    reg [12:0] counter;
    reg [3:0] count_reg;

    // State machine logic
    always_comb begin
        next_state = state;
        counting = 0;
        done = 0;

        case (state)
            IDLE: begin
                if (data == 1) begin
                    next_state = DETECT_1;
                end
            end
            DETECT_1: begin
                if (data == 1) begin
                    next_state = DETECT_2;
                end else begin
                    next_state = IDLE;
                end
            end
            DETECT_2: begin
                if (data == 0) begin
                    next_state = DETECT_3;
                end else begin
                    next_state = IDLE;
                end
            end
            DETECT_3: begin
                if (data == 1) begin
                    next_state = GET_DELAY_0;
                end else begin
                    next_state = IDLE;
                end
            end
            GET_DELAY_0: begin
                delay[3] = data;
                next_state = GET_DELAY_1;
            end
            GET_DELAY_1: begin
                delay[2] = data;
                next_state = GET_DELAY_2;
            end
            GET_DELAY_2: begin
                delay[1] = data;
                next_state = GET_DELAY_3;
            end
            GET_DELAY_3: begin
                delay[0] = data;
                next_state = COUNTING;
            end
            COUNTING: begin
                counting = 1;
                if (counter == 13'd999) begin
                    if (count_reg == 4'd0) begin
                        next_state = DONE;
                    end else begin
                        count_reg = count_reg - 1;
                        counter = 13'd0;
                    end
                end
            end
            DONE: begin
                done = 1;
                if (ack == 1) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // State register update
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 13'd0;
            count_reg <= 4'd0;
        end else begin
            state <= next_state;
            if (state == COUNTING) begin
                if (counter == 13'd999) begin
                    counter <= 13'd0;
                end else begin
                    counter <= counter + 1;
                end
            end else if (state == GET_DELAY_3) begin
                counter <= 13'd0;
                count_reg <= delay;

            end
        end
    end


    assign count = count_reg;

endmodule