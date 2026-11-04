"""
module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

  reg [3:0] state;
  reg f_reg;
  reg g_reg;

  parameter A = 4'b0000;
  parameter B = 4'b0001;
  parameter C = 4'b0010;
  parameter D = 4'b0011;
  parameter E = 4'b0100;
  parameter F = 4'b0101;
  parameter G = 4'b0110;
  parameter H = 4'b0111;
  parameter I = 4'b1000;
  parameter J = 4'b1001;

  always @(posedge clk) begin
    if (!resetn) begin
      state <= A;
      f_reg <= 0;
      g_reg <= 0;
    end else begin
      case (state)
        A: begin
          state <= B;
          f_reg <= 0;
          g_reg <= 0;
        end
        B: begin
          state <= C;
          f_reg <= 1;
          g_reg <= 0;
        end
        C: begin
          state <= D;
          f_reg <= 0;
          g_reg <= 0;
        end
        D: begin
          if (x == 1) begin
            state <= E;
          end else begin
            state <= D;
          end
          f_reg <= 0;
          g_reg <= 0;
        end
        E: begin
          if (x == 0) begin
            state <= F;
          end else begin
            state <= D;
          end
          f_reg <= 0;
          g_reg <= 0;
        end
        F: begin
          if (x == 1) begin
            state <= G;
          end else begin
            state <= D;
          end
          f_reg <= 0;
          g_reg <= 0;
        end
        G: begin
          state <= H;
          f_reg <= 0;
          g_reg <= 1;
        end
        H: begin
          if (y == 1) begin
            state <= J;
          end else begin
            state <= I;
          end
          f_reg <= 0;
          g_reg <= 1;
        end
        I: begin
          if (y == 1) begin
            state <= J;
          end else begin
            state <= A;
          end
          f_reg <= 0;
          g_reg <= 0;
        end
        J: begin
          state <= J;
          f_reg <= 0;
          g_reg <= 1;
        end
        default: begin
          state <= A;
          f_reg <= 0;
          g_reg <= 0;
        end
      endcase
    end
  end

  assign f = f_reg;
  assign g = g_reg;

endmodule


module dual_edge_ff (
    input clk,
    input d,
    output q
);

reg prev_clk;
reg edge;
reg q_reg;

always @(posedge clk) begin
    prev_clk <= clk;
    edge <= clk ^ prev_clk; // Detect rising and falling edges
    if (edge) begin
        q_reg <= d; // Update output on edge
    end
end

assign q = q_reg;

endmodule

//----------------------------------------------------------------------------
// Finite State Machine for Motor Control
//----------------------------------------------------------------------------
"""
module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
localparam A = 0, // Reset state
           B = 1, // f = 1 for one cycle
           C = 2, // Monitoring x (1)
           D = 3, // Monitoring x (0)
           E = 4, // Monitoring x (1)
           F = 5, // g = 1, monitoring y
           G = 6, // g = 1 permanently
           H = 7; // g = 0 permanently

reg [2:0] current_state;
reg [2:0] next_state;
reg [1:0] y_counter; // Counter to track how many cycles have passed without y = 1

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
        f <= 0;
        g <= 0;
        y_counter <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            B: f <= 0;
            default: f <= 0; //f is zero in all other states
        endcase
    end
end

always @(*) begin
    next_state = current_state;
    f = 0;
    case (current_state)
        A: begin
            next_state = B;
            f = 1;
            g = 0;
            y_counter = 0;
        end
        B: begin
            next_state = C;
            f = 0;
        end
        C: begin
            if (x == 1) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        D: begin
            if (x == 0) begin
                next_state = E;
            end else begin
                next_state = C;
            end
        end
        E: begin
            if (x == 1) begin
                next_state = F;
                g = 1;
                y_counter = 0;
            end else begin
                next_state = C;
                g = 0;
            end
        end
        F: begin
            if (y == 1) begin
                next_state = G;
                g = 1;
            end else begin
                if (y_counter < 1) begin
                    next_state = F;
                    g = 1;
                    y_counter = y_counter + 1;
                end else begin
                    next_state = H;
                    g = 0;
                    y_counter = 0;
                end
            end
        end
        G: begin
            next_state = G;
            g = 1;
            y_counter = 0;
        end
        H: begin
            next_state = H;
            g = 0;
            y_counter = 0;
        end
        default: begin
          next_state = A;
          f = 0;
          g = 0;
          y_counter = 0;
        end
    endcase
end

endmodule

VCD info: dumpfile wave.vcd opened for output.
Hint: Output 'f' has 37 mismatches. First mismatch occurred at time 10.
Hint: Output 'g' has 40 mismatches. First mismatch occurred at time 55.
Hint: Total mismatched samples is 77 out of 1002 samples

Simulation finished at 5011 ps
Mismatches: 77 in 1002 samples