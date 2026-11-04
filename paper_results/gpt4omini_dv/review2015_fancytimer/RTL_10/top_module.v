module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);
    reg [3:0] delay;
    reg [10:0] counter; // Counter to track (delay + 1) * 1000 cycles
    reg [3:0] state; // State register
    reg seq_detected;
    reg [3:0] shift_reg; // Shift register for data

    // State encoding
    localparam IDLE = 4'd0;
    localparam DETECT = 4'd1;
    localparam SHIFT = 4'd2;
    localparam COUNT = 4'd3;
    localparam DONE = 4'd4;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 4'b0000;
            counting <= 0;
            done <= 0;
            counter <= 0;
            delay <= 4'b0000;
            shift_reg <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    if (data == 1'b1) begin
                        seq_detected <= 1;
                    end else begin
                        seq_detected <= 0;
                    end
                    if (seq_detected) begin
                        state <= DETECT;
                        shift_reg <= {shift_reg[2:0], data}; // Shift in the data bit
                    end
                end

                DETECT: begin
                    shift_reg <= {shift_reg[2:0], data}; // Shift in the data bit
                    if (shift_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_reg <= 4'b0000; // Reset shift register
                    end
                end

                SHIFT: begin
                    delay <= {data, shift_reg[3:1]}; // Capture next 4 bits into delay
                    counter <= (delay + 1) * 1000;
                    counting <= 1;
                    state <= COUNT;
                end

                COUNT: begin
                    if (counter > 0) begin
                        counter <= counter - 1;
                        count <= counter / 1000; // Update count output for current remaining time
                    end
                    if (counter == 0) begin
                        counting <= 0;
                        done <= 1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE; // Reset to search for next sequence
                    end
                end
            endcase
        end
    end
endmodule