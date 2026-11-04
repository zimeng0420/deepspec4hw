module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum logic [2:0] {
        IDLE,
        START_BIT,
        DATA_RECEIVE_0,
        DATA_RECEIVE_1,
        DATA_RECEIVE_2,
        DATA_RECEIVE_3,
        DATA_RECEIVE_4,
        DATA_RECEIVE_5,
        DATA_RECEIVE_6,
        DATA_RECEIVE_7,
        STOP_BIT,
        ERROR
    } state_t;

    state_t current_state, next_state;
    reg [3:0] bit_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            out_byte <= 8'b0;
            done <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (current_state == IDLE) begin
            done <= 0;
        end else if (current_state == STOP_BIT) begin
            done <= 1;
        end
    end

    always_ff @(posedge clk) begin
        case (current_state)
            IDLE: begin
                if (in == 0) begin // Start bit detected
                    next_state <= START_BIT;
                    bit_count <= 0;
                    out_byte <= 8'b0;
                end else begin
                    next_state <= IDLE;
                end
            end
            START_BIT: begin
                next_state <= DATA_RECEIVE_0;
            end
            DATA_RECEIVE_0: begin
                out_byte[0] <= in;
                bit_count <= bit_count + 1;
                next_state <= (bit_count == 7) ? STOP_BIT : DATA_RECEIVE_1;
            end
            DATA_RECEIVE_1: begin
                out_byte[1] <= in;
                bit_count <= bit_count + 1;
                next_state <= (bit_count == 7) ? STOP_BIT : DATA_RECEIVE_2;
            end
            DATA_RECEIVE_2: begin
                out_byte[2] <= in;
                bit_count <= bit_count + 1;
                next_state <= (bit_count == 7) ? STOP_BIT : DATA_RECEIVE_3;
            end
            DATA_RECEIVE_3: begin
                out_byte[3] <= in;
                bit_count <= bit_count + 1;
                next_state <= (bit_count == 7) ? STOP_BIT : DATA_RECEIVE_4;
            end
            DATA_RECEIVE_4: begin
                out_byte[4] <= in;
                bit_count <= bit_count + 1;
                next_state <= (bit_count == 7) ? STOP_BIT : DATA_RECEIVE_5;
            end
            DATA_RECEIVE_5: begin
                out_byte[5] <= in;
                bit_count <= bit_count + 1;
                next_state <= (bit_count == 7) ? STOP_BIT : DATA_RECEIVE_6;
            end
            DATA_RECEIVE_6: begin
                out_byte[6] <= in;
                bit_count <= bit_count + 1;
                next_state <= (bit_count == 7) ? STOP_BIT : DATA_RECEIVE_7;
            end
            DATA_RECEIVE_7: begin
                out_byte[7] <= in;
                bit_count <= bit_count + 1;
                next_state <= STOP_BIT;
            end
            STOP_BIT: begin
                if (in == 1) // Correct stop bit
                    next_state <= IDLE;
                else
                    next_state <= ERROR; // Error state if stop bit not received
            end
            ERROR: begin
                if (in == 1)
                    next_state <= IDLE; // Reset on finding idle (1)
                else
                    next_state <= ERROR;
            end
            default: next_state <= IDLE;
        endcase
    end

endmodule