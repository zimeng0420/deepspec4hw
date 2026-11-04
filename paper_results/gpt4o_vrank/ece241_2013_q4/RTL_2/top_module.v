module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);
    // State encoding
    typedef enum reg [1:0] {
        LOW = 2'b00,
        BETWEEN_S1_S2 = 2'b01,
        BETWEEN_S2_S3 = 2'b10,
        ABOVE_S3 = 2'b11
    } state_t;
    
    // State registers
    reg [1:0] current_state, next_state;
    reg last_sensor_increased;

    // Sequential logic: state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= LOW;
            last_sensor_increased <= 1'b0;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic: next state and outputs
    always @(*) begin
        // Default outputs
        fr1 = 1'b0;
        fr2 = 1'b0;
        fr3 = 1'b0;
        dfr = 1'b0;
        
        // Determine next state
        case (current_state)
            LOW: begin
                if (s == 3'b000) begin
                    next_state = LOW;
                    fr1 = 1'b1;
                    fr2 = 1'b1;
                    fr3 = 1'b1;
                end else if (s == 3'b001) begin
                    next_state = BETWEEN_S1_S2;
                    last_sensor_increased = 1'b1;
                end else if (s == 3'b011) begin
                    next_state = BETWEEN_S2_S3;
                    last_sensor_increased = 1'b1;
                end else begin
                    next_state = ABOVE_S3;
                    last_sensor_increased = 1'b1;
                end
            end
            
            BETWEEN_S1_S2: begin
                if (s == 3'b000) begin
                    next_state = LOW;
                    fr1 = 1'b1;
                    fr2 = 1'b1;
                    fr3 = 1'b1;
                end else if (s == 3'b001) begin
                    next_state = BETWEEN_S1_S2;
                    fr1 = 1'b1;
                    fr2 = 1'b1;
                    dfr = last_sensor_increased;
                end else if (s == 3'b011) begin
                    next_state = BETWEEN_S2_S3;
                    last_sensor_increased = 1'b1;
                end else begin
                    next_state = ABOVE_S3;
                    last_sensor_increased = 1'b1;
                end
            end

            BETWEEN_S2_S3: begin
                if (s == 3'b000) begin
                    next_state = LOW;
                    fr1 = 1'b1;
                    fr2 = 1'b1;
                    fr3 = 1'b1;
                end else if (s == 3'b001) begin
                    next_state = BETWEEN_S1_S2;
                    last_sensor_increased = 1'b0;
                end else if (s == 3'b011) begin
                    next_state = BETWEEN_S2_S3;
                    fr1 = 1'b1;
                    dfr = last_sensor_increased;
                end else begin
                    next_state = ABOVE_S3;
                    last_sensor_increased = 1'b1;
                end
            end

            ABOVE_S3: begin
                if (s == 3'b000) begin
                    next_state = LOW;
                    fr1 = 1'b1;
                    fr2 = 1'b1;
                    fr3 = 1'b1;
                end else if (s == 3'b001) begin
                    next_state = BETWEEN_S1_S2;
                    last_sensor_increased = 1'b0;
                end else if (s == 3'b011) begin
                    next_state = BETWEEN_S2_S3;
                    last_sensor_increased = 1'b0;
                end else begin
                    next_state = ABOVE_S3;
                end
            end

            default: begin
                next_state = LOW;
            end
        endcase
    end
endmodule