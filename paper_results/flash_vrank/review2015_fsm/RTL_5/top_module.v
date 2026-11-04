module top_module(
	input clk,
	input reset,
	input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    // Define state encoding
    localparam IDLE = 0;
    localparam S1 = 1;
    localparam S2 = 2;
    localparam S3 = 3;
    localparam SHIFTING = 4;
    localparam COUNTING = 5;
    localparam DONE = 6;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                    if (data == 1) begin
                        state <= S1;
                    end else begin
                        state <= IDLE;
                    end
                end
                S1: begin
                    if (data == 1) begin
                        state <= S2;
                    end else begin
                        state <= IDLE;
                    end
                end
                S2: begin
                    if (data == 0) begin
                        state <= S3;
                    end else begin
                        state <= IDLE;
                    end
                end
                S3: begin
                    if (data == 1) begin
                        state <= SHIFTING;
						shift_ena <= 1;
                    end else begin
                        state <= IDLE;
						shift_ena <=0;
                    end
                end
                SHIFTING: begin
					if (shift_ena_count < 4) begin
						shift_ena <= 1;
					end
					else begin
						shift_ena <= 0;
						state <= COUNTING;
						counting <= 1;
					end
                end
                COUNTING: begin
                    shift_ena <= 0;
                    counting <= 1;
                    if (done_counting) begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end else begin
                        state <= COUNTING;
                    end
                end
                DONE: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end else begin
                        state <= DONE;
                    end
                end
                default: begin
                    state <= IDLE;
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                end
            endcase
        end
    end

	reg [2:0] shift_ena_count;

	always @(posedge clk) begin
		if (reset) begin
			shift_ena_count <= 0;
		end else begin
			if (state == SHIFTING) begin
				if (shift_ena_count < 4)
					shift_ena_count <= shift_ena_count + 1;
				else
					shift_ena_count <= 0;
			end else begin
				shift_ena_count <= 0;
			end
		end
	end

endmodule