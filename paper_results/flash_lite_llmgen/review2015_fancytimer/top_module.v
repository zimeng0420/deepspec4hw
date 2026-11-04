module top_module(
	input wire clk,
	input wire reset,
	input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    // State Definitions
    parameter IDLE       = 3'b000;
    parameter READ_DELAY = 3'b001;
    parameter COUNTING   = 3'b010;
    parameter DONE       = 3'b011;

    // Internal Signals
    reg [2:0] state;
    reg [3:0] delay;
    reg [12:0] counter; // Counter for clock cycles (up to 8000)
    reg [3:0] count_internal; // Internal count register
    reg [1:0] bit_counter; // Counter for shifting in delay bits
    reg [3:0] shift_reg; // Shift register for start sequence detection

    // FSM Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            delay <= 0;
            counter <= 0;
            count_internal <= 0;
            bit_counter <= 0;
            shift_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    counting <= 0;
                    // Shift in data to detect start sequence
                    shift_reg <= {shift_reg[0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= READ_DELAY;
                        bit_counter <= 0;
                    end
                end
                READ_DELAY: begin
                    // Shift in delay bits
                    delay[3:0] <= {delay[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 3) begin
                        state <= COUNTING;
                        counter <= (delay + 1) * 1000 - 1; // Initialize counter
                        count_internal <= delay;
                        counting <= 1;
                    end
                end
                COUNTING: begin
                    counting <= 1;
                    if (counter == 0) begin
                        state <= DONE;
                        counting <= 0;
                    end else begin
                        counter <= counter - 1;
                        if (counter % 1000 == 999) begin // Update count every 1000 cycles
                            count_internal <= count_internal - 1;
                        end
                    end
                end
                DONE: begin
                    counting <= 0;
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Output Assignments
    assign count = (counting) ? count_internal : 4'b0000; // Don't care when not counting

endmodule