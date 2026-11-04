module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

  //----------------------------------------------------------------------------
  //  1.  Module Overview
  //----------------------------------------------------------------------------

  //  This module implements a Finite State Machine (FSM) to control a motor based
  //  on inputs x and y, derived from the motor's state. The FSM generates control
  //  signals f and g to manipulate the motor's operation.  The FSM is synchronous
  //  and uses a negative-edge triggered reset.

  //----------------------------------------------------------------------------
  //  2.  Functional Description
  //----------------------------------------------------------------------------

  //  2.1. Reset State (State A)
  //      - When resetn is low (logic 0), the FSM enters the reset state (State A).
  //      - In State A, the outputs f and g are forced to 0.
  //      - The FSM remains in State A as long as resetn is low.

  //  2.2. Initialization Pulse (State B)
  //      - When resetn transitions from low to high, the FSM transitions to State B
  //        on the next rising clock edge.
  //      - In State B, the output f is set to 1 for one clock cycle.
  //      - The output g remains at 0.

  //  2.3. X Sequence Detection (States C, D, E)
  //      - After State B, the FSM enters a sequence of states (C, D, E) to detect
  //        the input sequence x = 1, 0, 1.
  //      - State C: Waits for x = 1.
  //      - State D: Waits for x = 0 after x = 1.
  //      - State E: Waits for x = 1 after x = 1, 0.
  //      - If the sequence 1, 0, 1 is detected in three successive clock cycles,
  //        the FSM transitions to State F on the next clock edge.
  //      - If the sequence is interrupted (e.g., x = 0 in State C, x = 1 in State D,
  //        or x = 0 in State E), the FSM returns to State C to restart the sequence
  //        detection.

  //  2.4. G Activation and Y Monitoring (States F, G, H, I)
  //      - State F: Sets g = 1 for one clock cycle after the x sequence is detected.
  //      - States G and H: Monitor the y input for a value of 1 within two clock cycles.
  //      - State G: First clock cycle to monitor y.
  //      - State H: Second clock cycle to monitor y.
  //      - State I: Permanent g=1 state.
  //      - If y = 1 in either State G or State H, the FSM transitions to State I,
  //        where g remains permanently at 1 (until reset).
  //      - If y != 1 in both State G and State H, the FSM transitions to a state
  //        where g is permanently set to 0 (State J, described below).

  //  2.5. Permanent G = 1 State (State I)
  //      - In State I, the output g remains permanently at 1 until reset.
  //      - The FSM stays in State I indefinitely.

  //  2.6. Permanent G = 0 State (State J)
  //      - In State J, the output g remains permanently at 0 until reset.
  //      - The FSM stays in State J indefinitely.

  //----------------------------------------------------------------------------
  //  3.  State Encoding
  //----------------------------------------------------------------------------

  //  The FSM uses the following state encoding:

  localparam STATE_A = 4'b0001;  // Reset State
  localparam STATE_B = 4'b0010;  // Initialization Pulse
  localparam STATE_C = 4'b0011;  // X Sequence - Wait for 1
  localparam STATE_D = 4'b0100;  // X Sequence - Wait for 0
  localparam STATE_E = 4'b0101;  // X Sequence - Wait for 1
  localparam STATE_F = 4'b0110;  // G Activation
  localparam STATE_G = 4'b0111;  // Y Monitoring - Cycle 1
  localparam STATE_H = 4'b1000;  // Y Monitoring - Cycle 2
  localparam STATE_I = 4'b1001;  // Permanent G = 1
  localparam STATE_J = 4'b1010;  // Permanent G = 0

  //----------------------------------------------------------------------------
  //  4.  Internal Signals
  //----------------------------------------------------------------------------

  reg [3:0] current_state;
  reg [3:0] next_state;
  reg       f_reg;
  reg       g_reg;

  //----------------------------------------------------------------------------
  //  5.  State Register
  //----------------------------------------------------------------------------

  always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      current_state <= STATE_A;
    end else begin
      current_state <= next_state;
    end
  end

  //----------------------------------------------------------------------------
  //  6.  Next State Logic
  //----------------------------------------------------------------------------

  always @(*) begin
    next_state = current_state; // Default: Stay in the same state
    case (current_state)
      STATE_A:  next_state = STATE_B;
      STATE_B:  next_state = STATE_C;
      STATE_C:  next_state = (x == 1'b1) ? STATE_D : STATE_C;
      STATE_D:  next_state = (x == 1'b0) ? STATE_E : STATE_C;
      STATE_E:  next_state = (x == 1'b1) ? STATE_F : STATE_C;
      STATE_F:  next_state = STATE_G;
      STATE_G:  next_state = (y == 1'b1) ? STATE_I : STATE_H;
      STATE_H:  next_state = (y == 1'b1) ? STATE_I : STATE_J;
      STATE_I:  next_state = STATE_I;
      STATE_J:  next_state = STATE_J;
      default: next_state = STATE_A; // Error condition: Return to reset state
    endcase
  end

  //----------------------------------------------------------------------------
  //  7.  Output Logic
  //----------------------------------------------------------------------------

  always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      f_reg <= 1'b0;
      g_reg <= 1'b0;
    end else begin
      case (current_state)
        STATE_A: begin
          f_reg <= 1'b0;
          g_reg <= 1'b0;
        end
        STATE_B: begin
          f_reg <= 1'b1;
          g_reg <= 1'b0;
        end
        STATE_C: begin
          f_reg <= 1'b0;
          g_reg <= 1'b0;
        end
        STATE_D: begin
          f_reg <= 1'b0;
          g_reg <= 1'b0;
        end
        STATE_E: begin
          f_reg <= 1'b0;
          g_reg <= 1'b0;
        end
        STATE_F: begin
          f_reg <= 1'b0;
          g_reg <= 1'b1;
        end
        STATE_G: begin
          f_reg <= 1'b0;
          g_reg <= 1'b1;
        end
        STATE_H: begin
          f_reg <= 1'b0;
          g_reg <= 1'b1;
        end
        STATE_I: begin
          f_reg <= 1'b0;
          g_reg <= 1'b1;
        end
        STATE_J: begin
          f_reg <= 1'b0;
          g_reg <= 1'b0;
        end
        default: begin
          f_reg <= 1'b0;
          g_reg <= 1'b0;
        end
      endcase
    end
  end

  assign f = f_reg;
  assign g = g_reg;

endmodule