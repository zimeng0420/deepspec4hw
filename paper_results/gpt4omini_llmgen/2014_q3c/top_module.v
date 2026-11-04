module top_module (
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

// State Encoding
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

// Next state and output logic
always @(posedge clk) begin
    case (y)
        S0: begin
            if (x == 0) begin
                Y0 <= S0; 
                z <= 0;
            end else begin
                Y0 <= S1; 
                z <= 0;
            end
        end
        S1: begin
            if (x == 0) begin
                Y0 <= S1; 
                z <= 0;
            end else begin
                Y0 <= S4; 
                z <= 0;
            end
        end
        S2: begin
            if (x == 0) begin
                Y0 <= S2; 
                z <= 0;
            end else begin
                Y0 <= S1; 
                z <= 0;
            end
        end
        S3: begin
            if (x == 0) begin
                Y0 <= S1; 
                z <= 1;
            end else begin
                Y0 <= S2; 
                z <= 1;
            end
        end
        S4: begin
            if (x == 0) begin
                Y0 <= S3; 
                z <= 1;
            end else begin
                Y0 <= S4; 
                z <= 1;
            end
        end
        default: begin
            Y0 <= S0; 
            z <= 0;
        end
    endcase
end

endmodule