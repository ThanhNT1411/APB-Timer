# TIMER MODULE
Timer module is customized from CLINT module of industrial RISC-V architecture
The timer has following features:
- 64-bit count-up
- 12-bit address
- Register set is configured via APB bus (IP is APB slave).
- Support wait state (1 cycle is enough) and error handling
- Support byte access
- Support halt (stop) in debug mode
- Timer uses active low async reset.
- Counter can be counted based on system clock or divided up to 256.
- Support timer interrupt (can be enabled or disabled).

# DETAIL FUNCTIONAL DESCRIPTION
# APB slave / Register
- Read/write to reserved area is RAZ/WI (read as zero, write ignored)
- Support APB 32-bit transfer
- Support byte access: bus can access to individual bytes in the register.
- Support wait state (1cycle) to improve the timing.
- Support error handling for some prohibited access:
    + write prohibited value to TCR.div_val
    + div_en or div_val changes during timer is operating
    + When error occurs, data is not written into register bit/fields

# Counter
- 64-bit count-up.
- Counting mode:
    + Default mode: counter’s speed is same as system clock.
    + Control mode: when enabled by writing 1 to TCR.div_en bit, the counter's speed is determined by
- the divisor value set in TCR.div_val
- Counter continues counting when interrupts occurs.
- Counter continues counting when overflow occurs.
- support halted mode describe in next page.
- When timer_en changes from H->L, the counter is cleared to its initial value by timer itself (hardware). When timer_en is L->H again, timer can work normally.
Note: the div_en and div_val is not related to frequency divisor (clock divider). Those settings only control the counter when to count.

# Counting mode:
- In default mode, counting speed depend on system clock (same as div_val=0 case as below waveform).
- The counting’s speed can be controlled by register settings by setting into TCR.div_en and TCR.div_val[3:0] as the register specification
- div_en and div_val can not be changed during timer_en is High.
- not allow to change div_en and div_val while timer_en is High by an error response when user mistakenly accesses.

# Halted mode
- Counter can be halted (stopped) in debug mode when both below conditions occur:
    + Input debug_mode signal is High,
    + THCR.halt_req is 1.
- THCSR.halt_ack is 1 after a halt request indicates that the request is accepted.
- After halted, counter can be resumed to count normally when clearing the halt request to 0.
- The period of each counting number needs to be same when halt and not halt as described in the below waveform example (div_val=2).

# Timer Interrupt
- Timer interrupt (tim_int) is asserted (set) when interrupt is enabled and counter’s value matches (equal) the compare value.
- Once asserted, the timer interrupt (tim_int) remains unchange until it is cleared by writing 1 to TISR.int_st bit or the interrupt is disabled.
