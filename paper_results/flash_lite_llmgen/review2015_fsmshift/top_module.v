module top_module(
	input clk,
	input reset,
	output reg shift_ena
);

    // State Definition
    parameter IDLE        = 2'b00;
    parameter SHIFT_ENA_1 = 2'b01;
    parameter SHIFT_ENA_2 = 2'b10;
    parameter SHIFT_ENA_3 = 2'b11;
    parameter SHIFT_ENA_4 = 2'b00; // Reuse IDLE state for DONE

    // Internal Signals
    reg [1:0] state;
    reg [1:0] counter;

    // State Transition Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 2'b00; // Reset counter
            shift_ena <= 1'b0; // Ensure shift_ena is low on reset
        end else begin
            case (state)
                IDLE: begin
                    if (reset) begin
                        state <= SHIFT_ENA_1;
                        shift_ena <= 1'b1;
                        counter <= 2'b01;
                    end
                end
                SHIFT_ENA_1: begin
                    state <= SHIFT_ENA_2;
                    counter <= counter + 1'b1;
                end
                SHIFT_ENA_2: begin
                    state <= SHIFT_ENA_3;
                    counter <= counter + 1'b1;
                end
                SHIFT_ENA_3: begin
                    state <= SHIFT_ENA_4;
                    counter <= counter + 1'b1;
                end
                SHIFT_ENA_4: begin
                    state <= IDLE; // Go back to IDLE after 4 cycles
                    shift_ena <= 1'b0;
                    counter <= 2'b00;
                end
                default: begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                    counter <= 2'b00;
                end
            endcase
        end
    end

endmodule