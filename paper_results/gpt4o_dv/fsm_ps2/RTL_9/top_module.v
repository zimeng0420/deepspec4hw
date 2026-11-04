module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    typedef enum logic [1:0] {
        WAIT_FOR_FIRST_BYTE = 2'b00,
        RECEIVE_SECOND_BYTE = 2'b01,
        RECEIVE_THIRD_BYTE  = 2'b10
    } state_t;
    
    state_t state, next_state;
    reg [1:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_FIRST_BYTE;
            byte_count <= 2'b00;
        end else begin
            state <= next_state;

            // Update byte count logic
            if (state != WAIT_FOR_FIRST_BYTE) begin
                byte_count <= byte_count + 2'b01;
            end else if (in[3] == 1) begin
                byte_count <= 2'b01;
            end else begin
                byte_count <= 2'b00;
            end
        end
    end

    always @(*) begin
        // Default assignment
        done = 0;
        next_state = state;

        case (state)
            WAIT_FOR_FIRST_BYTE: begin
                if (in[3] == 1) begin
                    next_state = RECEIVE_SECOND_BYTE;
                end
            end
            
            RECEIVE_SECOND_BYTE: begin
                next_state = RECEIVE_THIRD_BYTE;
            end
            
            RECEIVE_THIRD_BYTE: begin
                done = 1;
                if (in[3] == 1) begin
                    next_state = RECEIVE_SECOND_BYTE;
                end else begin
                    next_state = WAIT_FOR_FIRST_BYTE;
                end
            end
            
            default: next_state = WAIT_FOR_FIRST_BYTE;
        endcase
    end

endmodule