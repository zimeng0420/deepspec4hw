module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State definitions
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b10,
        DONE  = 2'b11
    } state_t;
    
    state_t state, next_state;

    // Registers
    reg [3:0] shift_reg;
    reg [3:0] delay_reg;
    reg [15:0] counter;
    reg [9:0] slow_counter;
    
    // Sequential logic for state and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            delay_reg <= 4'b0;
            counter <= 16'b0;
            slow_counter <= 10'b0;
            done <= 1'b0;
            counting <= 1'b0;
            count <= 4'b0;
        end
        else begin
            state <= next_state;
            if (state == IDLE) begin
                shift_reg <= {shift_reg[2:0], data};
            end
            else if (state == SHIFT) begin
                delay_reg <= {delay_reg[2:0], data};
            end
            else if (state == COUNT) begin
                if (slow_counter == 10'd999) begin
                    counter <= counter - 1;
                    slow_counter <= 10'b0;
                end
                else begin
                    slow_counter <= slow_counter + 1;
                end
            end
            else if (state == DONE) begin
                if (ack) begin
                    done <= 1'b0;
                end
            end
            if (state == COUNT) begin
                count <= counter[15:12]; // Assuming counter[15:12] corresponds to current delay step
            end
            counting <= (state == COUNT);
            done <= (state == DONE);
        end
    end

    // Combinational logic for next state
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                if (&delay_reg) begin // After 4 shifts
                    next_state = COUNT;
                end
            end
            COUNT: begin
                if (counter == 16'b0) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Calculate initial counter value in terms of clock cycles
    always @(posedge clk) begin
        if (state == SHIFT && next_state == COUNT) begin
            counter <= (delay_reg + 1) * 1000;
        end
    end

endmodule