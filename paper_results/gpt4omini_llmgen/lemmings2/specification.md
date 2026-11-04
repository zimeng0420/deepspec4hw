### Technical Specification for Lemming State Machine Module

#### Module Description
This module implements a finite state machine (FSM) that models the behavior of a Lemming in a 2D world based on specified inputs. The FSM governs the walking direction and falling state of the Lemming, responding to bumps and ground status.

#### Inputs
- **clk**: Clock signal (active high).
- **areset**: Asynchronous active high reset signal to initialize the FSM to the "walk left" state.
- **bump_left**: Active high signal that indicates the Lemming is bumped from the left.
- **bump_right**: Active high signal that indicates the Lemming is bumped from the right.
- **ground**: Active high signal indicating the presence of ground beneath the Lemming.

#### Outputs
- **walk_left**: Active high signal indicating the Lemming is walking left (1 if walking left, 0 otherwise).
- **walk_right**: Active high signal indicating the Lemming is walking right (1 if walking right, 0 otherwise).
- **aaah**: Active high signal indicating the Lemming is falling (1 if falling, 0 otherwise).

#### State Definitions
1. **STATE_WALK_LEFT**: The Lemming is walking left.
2. **STATE_WALK_RIGHT**: The Lemming is walking right.
3. **STATE_FALLING**: The Lemming is falling.

#### State Transitions
1. On **areset**:
   - Transition to **STATE_WALK_LEFT**.

2. From **STATE_WALK_LEFT**:
   - If `ground` = 0: Transition to **STATE_FALLING**.
   - If `bump_right` = 1: Transition to **STATE_WALK_RIGHT**.
   - Remain in **STATE_WALK_LEFT** on `bump_left` or in absence of bumps.

3. From **STATE_WALK_RIGHT**:
   - If `ground` = 0: Transition to **STATE_FALLING**.
   - If `bump_left` = 1: Transition to **STATE_WALK_LEFT**.
   - Remain in **STATE_WALK_RIGHT** on `bump_right` or in absence of bumps.

4. From **STATE_FALLING**:
   - If `ground` = 1: Transition back to previous walking state (either **STATE_WALK_LEFT** or **STATE_WALK_RIGHT**, depending on last direction).
   - Maintain **STATE_FALLING** for any bumps as they do not affect the walking direction while falling.

#### Outputs Generation
- In **STATE_WALK_LEFT**: 
  - Set `walk_left = 1`, `walk_right = 0`, `aaah = 0`.
  
- In **STATE_WALK_RIGHT**:
  - Set `walk_left = 0`, `walk_right = 1`, `aaah = 0`.

- In **STATE_FALLING**:
  - Set `walk_left = 0`, `walk_right = 0`, `aaah = 1`.

#### Additional Considerations
- Ensure proper synchronization with the clock signal for state transitions.
- Use a register to hold the current state of the FSM.
- Handle the asynchronous reset logic in a manner that does not disturb the operation of the FSM during normal operation.
- Test edge cases such as simultaneous bumps and ground transitions to ensure correct state behavior. 

This specification outlines the behavior of the Lemming's finite state machine, encompassing the required inputs, outputs, state management, and transition rules within the given game's mechanics.