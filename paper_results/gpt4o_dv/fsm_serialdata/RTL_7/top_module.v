module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State declarations
    typedef enum reg [2:0] {
        IDLE,
        START,
        DATA,
        STOP,
        ERROR
    } state_t;
    
    state_t state, next_state;
    reg [3:0] bit_counter;
    reg [7:0] shift_register;

    // State transition
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic and Output logic
    always @(*) begin
        // Default values
        next_state = state;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_counter == 4'd8)
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1) begin
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
        endcase
    end

    // Data reception logic
    always @(posedge clk) begin
        if (state == DATA) begin
            if (bit_counter < 4'd8) 
                bit_counter <= bit_counter + 1'b1;
            shift_register <= {in, shift_register[7:1]};
        end else if (state == IDLE || state == ERROR) begin
            bit_counter <= 4'd0;
            shift_register <= 8'b0;
        end
    end

    // Load the output byte on completion
    always @(posedge clk) begin
        if (done)
            out_byte <= shift_register;
    end

endmodule