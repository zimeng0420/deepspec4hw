module top_module (
    input clk,
    input in,
    input reset,
    output done
);

    reg [3:0] state;
    reg done_r;

    parameter IDLE = 4'b0000;
    parameter START = 4'b0001;
    parameter BIT0 = 4'b0010;
    parameter BIT1 = 4'b0011;
    parameter BIT2 = 4'b0100;
    parameter BIT3 = 4'b0101;
    parameter BIT4 = 4'b0110;
    parameter BIT5 = 4'b0111;
    parameter BIT6 = 4'b1000;
    parameter BIT7 = 4'b1001;
    parameter STOP = 4'b1010;
    parameter ERROR = 4'b1011; // Added error state
	 parameter WAIT_STOP = 4'b1100;


    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_r <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done_r <= 0;
                    if (in == 0) begin
                        state <= START;
                    end else begin
                        state <= IDLE;
                    end
                end
                START: begin
                    state <= BIT0;
                end
                BIT0: begin
                    state <= BIT1;
                end
                BIT1: begin
                    state <= BIT2;
                end
                BIT2: begin
                    state <= BIT3;
                end
                BIT3: begin
                    state <= BIT4;
                end
                BIT4: begin
                    state <= BIT5;
                end
                BIT5: begin
                    state <= BIT6;
                end
                BIT6: begin
                    state <= BIT7;
                end
                BIT7: begin
                    if (in == 1) begin
                        state <= STOP;
                    end else begin
                        state <= ERROR;
                    end
                end
                STOP: begin
                    state <= IDLE;
                    done_r <= 1;
                end
					 
				ERROR: begin
					if (in == 1)
						state <= WAIT_STOP;
					else
						state <= ERROR;
				end

				WAIT_STOP: begin
					if(in == 1)
						state <= IDLE;
					else
						state <= WAIT_STOP;
				end

                default: begin
                    state <= IDLE;
                    done_r <= 0;
                end
            endcase
        end
    end

    assign done = done_r;

endmodule