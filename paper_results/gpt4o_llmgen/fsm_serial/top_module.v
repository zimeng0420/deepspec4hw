module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        RECEIVE = 2'b01,
        STOP_CHECK = 2'b10
    } state_t;

    state_t current_state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            bit_count <= 0;
            data_reg <= 8'b0;
        end else begin
            current_state <= next_state;
            if (current_state == RECEIVE) begin
                data_reg <= {in, data_reg[7:1]};
                bit_count <= bit_count + 1;
            end else if (current_state == STOP_CHECK && in == 1) begin
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (in == 0) begin
                    next_state = RECEIVE;
                end else begin
                    next_state = IDLE;
                end
            end
            RECEIVE: begin
                if (bit_count == 3'b111) begin
                    next_state = STOP_CHECK;
                end else begin
                    next_state = RECEIVE;
                end
            end
            STOP_CHECK: begin
                if (in == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = STOP_CHECK;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule