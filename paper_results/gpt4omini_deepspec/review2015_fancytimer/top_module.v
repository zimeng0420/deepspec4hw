module top_module(
	input wire clk,
	input wire reset,
	input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    reg [3:0] delay;
    reg [19:0] cycle_count; // to count up to 1000 cycles
    reg [3:0] remaining_time;
    reg [2:0] state, next_state;

    localparam SEARCH = 3'b000;
    localparam READ_DELAY = 3'b001;
    localparam COUNTING = 3'b010;
    localparam DONE = 3'b011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= SEARCH;
            counting <= 0;
            done <= 0;
            cycle_count <= 0;
            remaining_time <= 0;
        end else begin
            state <= next_state;
            case (state)
                COUNTING: begin
                    if (cycle_count < 1000 - 1) begin
                        cycle_count <= cycle_count + 1;
                    end else begin
                        cycle_count <= 0;
                        if (remaining_time > 0) begin
                            remaining_time <= remaining_time - 1;
                        end else begin
                            done <= 1; // Timer done
                            counting <= 0;
                            remaining_time <= 0; // reset remaining time
                        end
                    end
                end
                DONE: begin
                    if (ack) begin
                        counting <= 0;
                        done <= 0;
                        state <= SEARCH; // reset to searching state
                    end
                end
                default: begin
                    // Default state handling
                end
            endcase
        end
    end

    always @(posedge clk) begin
        case (state)
            SEARCH: begin
                // Search for pattern 1101
                if ({data, {data_prev}} == 4'b1101) begin
                    state <= READ_DELAY;
                end
            end
            READ_DELAY: begin
                // Shift in 4 bits to get delay
                delay <= {delay[2:0], data};
                // After 4 bits, transition to COUNTING state
                if (shift_done) begin // Assuming a mechanism to indicate this
                    remaining_time <= delay + 1; // delay is now stored
                    counting <= 1; // start counting
                    state <= COUNTING;
                end
            end
            default: begin
                // Handle other states/errors if needed
            end
        endcase
    end

    assign count = (counting) ? remaining_time : 4'bxxxx;

endmodule