module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg splatter
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam WALK_LEFT = 2'b01;
    localparam WALK_RIGHT = 2'b10;
    localparam FALLING = 2'b11;
    localparam DIGGING = 2'b01;
    localparam DIGGING_RIGHT = 2'b10;



    reg [1:0] state;
    reg [7:0] fall_counter;
    reg [1:0] dig_dir; // 00:Left, 01: Right
    reg prev_ground;

    // Default output values
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        splatter = 0;
    end

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 8'd0;
            dig_dir <= 2'b00;
            prev_ground <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    walk_left = 1;
                    walk_right = 0;
                    if (ground == 0) begin
                        state <= FALLING;
                        fall_counter <= 8'd0;
                    end else if (dig && ground) begin
                            state <= WALK_LEFT;
                            dig_dir <= 2'b00;
                        end
                    else if (bump_left) begin
                        state <= WALK_RIGHT;
                    end else if (bump_right) begin
                        state <= WALK_LEFT;
                    end
                end
                WALK_LEFT: begin
                    walk_left = 1;
                    walk_right = 0;
                    if (ground == 0) begin
                        state <= FALLING;
                        fall_counter <= 8'd0;
                    end else if (dig && ground) begin
                        state <= DIGGING;
                        dig_dir <= 2'b00;

                    end
                    else if (bump_right) begin
                        state <= WALK_LEFT;
                    end else if (bump_left) begin
                        state <= WALK_RIGHT;
                    end

                end

                WALK_RIGHT: begin
                    walk_left = 0;
                    walk_right = 1;
                    if (ground == 0) begin
                        state <= FALLING;
                        fall_counter <= 8'd0;
                    end else if (dig && ground) begin
                        state <= DIGGING_RIGHT;
                        dig_dir <= 2'b01;
                    end
                    else if (bump_left) begin
                        state <= WALK_RIGHT;
                    end else if (bump_right) begin
                        state <= WALK_LEFT;
                    end
                end
                 DIGGING: begin
                        walk_left = 1;
                        walk_right = 0;
                        if (ground == 0) begin
                             state <= FALLING;
                             fall_counter <= 8'd0;
                        end
                end

                DIGGING_RIGHT: begin
                        walk_left = 0;
                        walk_right = 1;
                        if (ground == 0) begin
                             state <= FALLING;
                             fall_counter <= 8'd0;
                        end
                end

                FALLING: begin
                    aaah = 1;
                    fall_counter <= fall_counter + 1'b1;
                    if (ground) begin
                        if (fall_counter > 8'd20) begin
                            splatter <= 1;
                            state <= IDLE; // Splattered
                        end else begin
                            if(dig_dir == 2'b00){
                               state <= WALK_LEFT;
                                } else if(dig_dir == 2'b01){
                                    state <= WALK_RIGHT;
                                }
                             else if (walk_left) begin
                                state <= WALK_LEFT;
                            end else if (walk_right) begin
                                state <= WALK_RIGHT;
                            end
                             else
                                state <= WALK_LEFT;
                        end
                        fall_counter <= 8'd0;
                    end
                end
            endcase
        end
    end

    // Previous ground
    always @(posedge clk or posedge areset) begin
        if (areset)
            prev_ground <= 1'b1;
        else
            prev_ground <= ground;
    end
end