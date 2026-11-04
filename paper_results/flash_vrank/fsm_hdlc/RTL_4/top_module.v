module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

  reg [3:0] state;

  localparam S_IDLE  = 4'b0000;
  localparam S_ONE   = 4'b0001;
  localparam S_TWO   = 4'b0010;
  localparam S_THREE = 4'b0011;
  localparam S_FOUR  = 4'b0100;
  localparam S_FIVE  = 4'b0101;
  localparam S_SIX   = 4'b0110;
  localparam S_SEVEN = 4'b0111;
  localparam S_EIGHT = 4'b1000;
  localparam S_DISC  = 4'b1001;
  localparam S_FLAG  = 4'b1010;
  localparam S_ERR   = 4'b1011;



  always @(posedge clk) begin
    if (reset) begin
      state <= S_IDLE;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end else begin
      disc <= 0;
      flag <= 0;
      err <= 0;

      case (state)
        S_IDLE: begin
          if (in == 1) begin
            state <= S_ONE;
          end else begin
            state <= S_IDLE;
          end
        end
        S_ONE: begin
          if (in == 1) begin
            state <= S_TWO;
          end else begin
            state <= S_IDLE;
          end
        end
        S_TWO: begin
          if (in == 1) begin
            state <= S_THREE;
          end else begin
            state <= S_IDLE;
          end
        end
        S_THREE: begin
          if (in == 1) begin
            state <= S_FOUR;
          end else begin
            state <= S_IDLE;
          end
        end
        S_FOUR: begin
          if (in == 1) begin
            state <= S_FIVE;
          end else begin
            state <= S_IDLE;
          end
        end
        S_FIVE: begin
          if (in == 1) begin
            state <= S_SIX;
          end else begin
            state <= S_IDLE;
          end
        end
        S_SIX: begin
          if (in == 1) begin
            state <= S_SEVEN;
          end else begin
            state <= S_DISC;
            disc <= 1;
          end
        end
        S_SEVEN: begin
          if (in == 1) begin
            state <= S_EIGHT;
          end else begin
            state <= S_FLAG;
            flag <= 1;
          end
        end
        S_EIGHT: begin
          if (in == 1) begin
            state <= S_ERR;
            err <= 1;
          end else begin
            state <= S_FLAG;
            flag <= 1;
          end
        end
        S_DISC: begin
            state <= S_IDLE;
        end
        S_FLAG: begin
            state <= S_IDLE;
        end
        S_ERR: begin
            state <= S_ERR;
            err <= 1;
        end
        default: state <= S_IDLE;
      endcase
    end
  end

endmodule