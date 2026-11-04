module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    reg [2:0] state;
    reg [3:0] delay;
    reg [19:0] cycle_count; // 20 bits for counting up to 1000
    reg [9:0] delay_count; // 10 bits for counting up to 1000

    localparam SEARCH = 3'd0;
    localparam RECEIVED = 3'd1;
    localparam COUNTING = 3'd2;
    localparam DONE = 3'd3;

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            done <= 0;
            counting <= 0;
            count <= 4'bxxxx; // Don't care state
            cycle_count <= 0;
            delay_count <= 0;
        end else begin
            case (state)
                SEARCH: begin
                    done <= 0;
                    counting <= 0;
                    count <= 4'bxxxx; // Don't care
                    // Shift detection for 1101
                    if ({data, data, data, prev_data} == 4'b1101) begin
                        state <= RECEIVED;
                        delay <= 4'b0; // Reset delay
                    end
                end

                RECEIVED: begin
                    // Shift in 4 bits for delay value
                    if (cycle_count < 4) begin
                        delay <= {delay[2:0], data};
                        cycle_count <= cycle_count + 1;
                    end else begin
                        cycle_count <= 0;
                        state <= COUNTING;
                        counting <= 1;
                    end
                end

                COUNTING: begin
                    if (delay_count < (delay + 1) * 1000) begin
                        if (delay > 0) begin
                            count <= delay;
                        end else begin
                            count <= 0;
                        end

                        delay_count <= delay_count + 1;

                        if (delay_count % 1000 == 0) begin
                            if (delay > 0) delay <= delay - 1;
                        end
                    end else begin
                        counting <= 0;
                        done <= 1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    count <= 4'bxxxx; // Don't care
                    if (ack) begin
                        state <= SEARCH; // Reset state
                    end
                end
            endcase
        end
    end
endmodule