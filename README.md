# Simple Stopwatch in Assembly

Project of stopwatch for Intel 8051 microcontroller.

## Stopwatch Functionality

- **Time Resolution**: The stopwatch displays time with a resolution of 10ms. The maximum time displayed is 99.99 seconds. Once this limit is reached, the stopwatch resets to zero and continues counting.
- **Initial Display**: Upon starting, the LCD screen shows `00.00` in the format `ss,MM`, where:
  - `ss`: Seconds
  - `MM`: Tenths of a second
- **Start/Stop Control**: The stopwatch can be started or stopped using the ENTER button (hex value `F`).
- **Buzzer Alert**: Every 10 seconds counted by the stopwatch is signaled with a 0.5-second buzzer sound.
- **Pause and Resume**:
  - When the stopwatch is stopped, the last measured time is displayed.
  - When resumed, the stopwatch continues counting from the last recorded time.
- **Interrupt Handling**: Time measurement and signaling each 10-second interval are managed using two separate interrupts (two Timers).

