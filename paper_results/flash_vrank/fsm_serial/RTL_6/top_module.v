module top_module (
    input clk,
    input in,
    input reset,
    output done
);

    reg done;

    // Define states
    parameter IDLE = 3'b000;
    parameter START = 3'b001;
    parameter DATA0 = 3'b010;
    parameter DATA1 = 3'b011;
    parameter DATA2 = 3'b100;
    parameter DATA3 = 3'b101;
    parameter DATA4 = 3'b110;
    parameter DATA5 = 3'b111;
    parameter DATA6 = 3'b000;
    parameter DATA7 = 3'b001;
    parameter STOP = 3'b010;
    parameter ERROR = 3'b011;


    reg [2:0] state;
    reg [2:0] next_state;
    reg [3:0] bit_count;


    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            bit_count <= 0;
        end else begin
            state <= next_state;
            if (next_state == STOP)
              done <= 1;
            else
              done <= 0;
        end
    end

    always @(*) begin
        next_state = state;  // Default next state is the current state
        case (state)
            IDLE: begin
                if (in == 0) begin
                    next_state = START;
                    bit_count = 0;
                end else begin
                  next_state = IDLE;
                  bit_count = 0;
                end
            end
            START: begin
              if (in == 1) begin
                next_state = ERROR;
              end else begin
                next_state = DATA0;
                bit_count = 0;
              end
            end

            DATA0: begin
                next_state = DATA1;
            end

            DATA1: begin
                next_state = DATA2;
            end

            DATA2: begin
                next_state = DATA3;
            end

            DATA3: begin
                next_state = DATA4;
            end

            DATA4: begin
                next_state = DATA5;
            end

            DATA5: begin
                next_state = DATA6;
            end

            DATA6: begin
                next_state = DATA7;
            end

            DATA7: begin
              next_state = STOP;
            end

            STOP: begin
                if (in == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end

            ERROR: begin
                if (in == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end


            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule