module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // FSM State Declarations
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b10,
        DONE = 2'b11
    } state_t;
    
    reg [3:0] shift_reg;
    reg [3:0] delay_reg;
    reg [15:0] counter;
    reg [9:0] count_cycle;
    state_t state, next_state;
    
    // Clock Process
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                if (delay_reg != 4'b0000) begin
                    next_state = COUNT;
                end
            end
            COUNT: begin
                if (counter == 0) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end
    
    // Pattern Detection & Delay Shifting
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
            delay_reg <= 4'b0000;
        end else begin
            if (state == IDLE) begin
                shift_reg <= {shift_reg[2:0], data};
            end else if (state == SHIFT) begin
                delay_reg <= {delay_reg[2:0], data};
            end
        end
    end

    // Counter
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'b0;
            count_cycle <= 10'b0;
        end else begin
            case (state)
                COUNT: begin
                    counting <= 1'b1;
                    if (count_cycle == 999) begin
                        count_cycle <= 0;
                        counter <= counter - 1'b1;
                    end else begin
                        count_cycle <= count_cycle + 1;
                    end
                end
                default: begin
                    counting <= 1'b0;
                end
            endcase
        end
    end

    // Remaining Time Calculation
    always @(*) begin
        if (counting) begin
            count = counter[15:12]; // Extract the relevant bits
        end else begin
            count = 4'bxxxx; // Don't-care state for count when not counting
        end
    end

    // Done Signal Logic
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else if (state == DONE) begin
            done <= 1'b1;
        end else if (state == IDLE && ack) begin
            done <= 1'b0;
        end
    end
    
endmodule