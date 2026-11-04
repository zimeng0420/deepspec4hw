module top_module(
	input clk,
	input reset,
	input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    // Define states
    parameter IDLE = 0;          // Waiting for start pattern (1101)
    parameter SHIFTING = 1;      // Shifting in duration bits
    parameter COUNTING = 2;      // Waiting for counters to finish
    parameter NOTIFY = 3;        // Notifying user timer is done
    
    // State register
    reg [1:0] state;

    // Internal registers for pattern detection
    reg [3:0] pattern_buffer;

    // Counter for shift_ena assertion
    reg [1:0] shift_ena_counter;

    // Default assignments
    always @(*) begin
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
    end

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_ena_counter <= 2'b00;
            pattern_buffer <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    pattern_buffer <= {pattern_buffer[2:0], data};
                    if (pattern_buffer == 4'b1101) begin
                        state <= SHIFTING;
                        shift_ena_counter <= 2'b00;
                    end else begin
                        state <= IDLE;
                    end
                end
                
                SHIFTING: begin
                    shift_ena <= 1'b1;
                    shift_ena_counter <= shift_ena_counter + 1;
                    if (shift_ena_counter == 2'b11) begin // 4 clock cycles
                        state <= COUNTING;
                    end else begin
                        state <= SHIFTING;
                    end
                end

                COUNTING: begin
                    counting <= 1'b1;
                    if (done_counting) begin
                        state <= NOTIFY;
                    end else begin
                        state <= COUNTING;
                    end
                end

                NOTIFY: begin
                    done <= 1'b1;
                    if (ack) begin
                        state <= IDLE;
                    end else begin
                        state <= NOTIFY;
                    end
                end

                default: begin
                    state <= IDLE; // Default to IDLE for safety
                    shift_ena_counter <= 2'b00;
                    pattern_buffer <= 4'b0000;
                end
            endcase
        end
    end

endmodule