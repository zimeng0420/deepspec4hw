module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

    reg [3:0] state;
    reg [3:0] delay;
    reg [3:0] bit_count;
    reg [13:0] cycle_count;

    localparam SEARCH        = 4'd0;
    localparam LOAD_DELAY    = 4'd1;
    localparam COUNT         = 4'd2;
    localparam DONE          = 4'd3;

    always @(posedge clk) begin
        if (reset) begin
            // Reset all signals
            state <= SEARCH;
            delay <= 0;
            bit_count <= 0;
            cycle_count <= 0;
            counting <= 0;
            done <= 0;
            count <= 4'd0;
        end else begin
            case (state)
                SEARCH: begin
                    counting <= 0;
                    done <= 0;
                    if (data == 1'b1) begin
                        bit_count <= bit_count + 1;
                    end else begin
                        bit_count <= 0;
                    end
                    if (bit_count == 4 && {bit_count, data} == 5'b001101) begin
                        state <= LOAD_DELAY;
                        bit_count <= 0;
                    end
                end
                
                LOAD_DELAY: begin
                    delay[3:0] <= {delay[2:0], data};
                    bit_count <= bit_count + 1;
                    if (bit_count == 4) begin
                        state <= COUNT;
                        cycle_count <= 0;
                        count <= delay;
                        counting <= 1;
                    end
                end
                
                COUNT: begin
                    if (cycle_count < 1000) begin
                        cycle_count <= cycle_count + 1;
                    end else begin
                        cycle_count <= 0;
                        if (count > 0) begin
                            count <= count - 1;
                        end else begin
                            counting <= 0;
                            done <= 1;
                            state <= DONE;
                        end
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= SEARCH;
                        done <= 0;
                    end
                end
            
            endcase
        end
    end

endmodule