#if (defined(__TARGET_CPU_CORTEX_M0PLUS) || defined(__TX_CORTEX_M0PLUS))
.cpu cortex-m0plus
#include "../ports/cortex_m0/src/tx_thread_context_restore.S"
#include "../ports/cortex_m0/src/tx_thread_context_save.S"
#include "../ports/cortex_m0/src/tx_thread_interrupt_control.S"
#include "../ports/cortex_m0/src/tx_thread_interrupt_disable.S"
#include "../ports/cortex_m0/src/tx_thread_interrupt_restore.S"
#include "../ports/cortex_m0/src/tx_thread_schedule.S"
#include "../ports/cortex_m0/src/tx_thread_stack_build.S"
#include "../ports/cortex_m0/src/tx_thread_system_return.S"
#include "../ports/cortex_m0/src/tx_timer_interrupt.S"
#elif (defined(__TARGET_CPU_CORTEX_M4) || defined(__TX_CORTEX_M4))
.cpu cortex-m4
#include "../ports/cortex_m4/src/tx_thread_context_restore.S"
#include "../ports/cortex_m4/src/tx_thread_context_save.S"
#include "../ports/cortex_m4/src/tx_thread_interrupt_control.S"
#include "../ports/cortex_m4/src/tx_thread_interrupt_disable.S"
#include "../ports/cortex_m4/src/tx_thread_interrupt_restore.S"
#include "../ports/cortex_m4/src/tx_thread_schedule.S"
#include "../ports/cortex_m4/src/tx_thread_stack_build.S"
#include "../ports/cortex_m4/src/tx_thread_system_return.S"
#include "../ports/cortex_m4/src/tx_timer_interrupt.S"
#elif (defined(__TARGET_CPU_CORTEX_M7) || defined(__TX_CORTEX_M7) || defined(__IMXRT1062__))
.cpu cortex-m7
#include "../ports/cortex_m7/src/tx_thread_context_restore.S"
#include "../ports/cortex_m7/src/tx_thread_context_save.S"
#include "../ports/cortex_m7/src/tx_thread_interrupt_control.S"
#include "../ports/cortex_m7/src/tx_thread_interrupt_disable.S"
#include "../ports/cortex_m7/src/tx_thread_interrupt_restore.S"
#include "../ports/cortex_m7/src/tx_thread_schedule.S"
#include "../ports/cortex_m7/src/tx_thread_stack_build.S"
#include "../ports/cortex_m7/src/tx_thread_system_return.S"
#include "../ports/cortex_m7/src/tx_timer_interrupt.S"
#else
#warning "Attempting to compile with ThreadX Cortex M0 port as a default, this may not work!"
#include "../ports/cortex_m0/src/tx_thread_context_restore.S"
#include "../ports/cortex_m0/src/tx_thread_context_save.S"
#include "../ports/cortex_m0/src/tx_thread_interrupt_control.S"
#include "../ports/cortex_m0/src/tx_thread_interrupt_disable.S"
#include "../ports/cortex_m0/src/tx_thread_interrupt_restore.S"
#include "../ports/cortex_m0/src/tx_thread_schedule.S"
#include "../ports/cortex_m0/src/tx_thread_stack_build.S"
#include "../ports/cortex_m0/src/tx_thread_system_return.S"
#include "../ports/cortex_m0/src/tx_timer_interrupt.S"
#endif

#if defined(__IMXRT1062__)
#include "../boards/teensy41/tx_initialize_low_level.S"
#else
#error "Unsupported board!"
#endif