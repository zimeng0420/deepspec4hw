module top_module (
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BYTE_1 = 2'b01,
        BYTE_2 = 2'b10,
        BYTE_3 = 2'b11
    } state_t;
    
    state_t state, next_state;
    reg [1:0] byte_count;
    
    // Sequential logic for state transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_count <= 2'd0;
        end else begin
            state <= next_state;
            if (next_state != IDLE) begin
                byte_count <= byte_count + 2'd1;
            end else begin
                byte_count <= 2'd0;
            end
        end
    end
    
    // Combinatorial logic for next state and done signal
    always @(*) begin
        next_state = state;
        done = 1'b0;
        
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE_1;
                end
            end
            BYTE_1: begin
                next_state = BYTE_2;
            end
            BYTE_2: begin
                next_state = BYTE_3;
            end
            BYTE_3: begin
                done = 1'b1; // Signal message done on the third byte
                if (in[3]) begin
                    next_state = BYTE_1;
                end else begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule