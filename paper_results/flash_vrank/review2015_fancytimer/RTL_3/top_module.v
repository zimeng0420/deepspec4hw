module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    reg [3:0] delay;
    reg [11:0] cycle_count;
    reg [3:0] current_delay;

    reg [3:0] state;

    localparam IDLE = 4'b0000;
    localparam BIT1 = 4'b0001;
    localparam BIT2 = 4'b0010;
    localparam BIT3 = 4'b0011;
    localparam GET_DELAY0 = 4'b0100;
    localparam GET_DELAY1 = 4'b0101;
    localparam GET_DELAY2 = 4'b0110;
    localparam GET_DELAY3 = 4'b0111;
    localparam COUNTING = 4'b1000;
    localparam DONE = 4'b1001;


    assign count = (counting) ? current_delay : 4'bx;


    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            cycle_count <= 0;
            current_delay <= 0;
            delay <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data) begin
                        state <= BIT1;
                    end
                end
                BIT1: begin
                    if (data) begin
                        state <= BIT2;
                    end else begin
                        state <= IDLE;
                    end
                end
                BIT2: begin
                    if (!data) begin
                        state <= BIT3;
                    end else begin
                        state <= IDLE;
                    end
                end
                BIT3: begin
                    if (data) begin
                        state <= GET_DELAY0;
                    end else begin
                        state <= IDLE;
                    end
                end
                GET_DELAY0: begin
                    delay[3] <= data;
                    state <= GET_DELAY1;
                end
                GET_DELAY1: begin
                    delay[2] <= data;
                    state <= GET_DELAY2;
                end
                GET_DELAY2: begin
                    delay[1] <= data;
                    state <= GET_DELAY3;
                end
                GET_DELAY3: begin
                    delay[0] <= data;
                    state <= COUNTING;
                    counting <= 1;
                    current_delay <= delay;
                    cycle_count <= 0;

                end
                COUNTING: begin
                    cycle_count <= cycle_count + 1;
                    if (cycle_count == 1000 - 1) begin
                        cycle_count <= 0;
                        if (current_delay > 0) begin
                            current_delay <= current_delay - 1;
                        end else begin
                            counting <= 0;
                            done <= 1;
                            state <= DONE;
                        end
                    end
                end
                DONE: begin
                    if (ack) begin
                        done <= 0;
                        state <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule