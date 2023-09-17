#include <Arduino.h>
#include <stdint.h>

extern void __tx_SysTickHandler();

static void __attribute((naked, noinline)) gpt1_isr() {
  GPT1_SR |= GPT_SR_OF1; // clear set bit
  __asm volatile("dsb");
  __tx_SysTickHandler();
}

void teensy_setup_timer() {
  // convert freq in Hz to a time period in us
  uint32_t DELAY_MICROSEC = 1000000 / TX_TIMER_TICKS_PER_SECOND;

  // attach our tick handler
  attachInterruptVector(IRQ_GPT1, &gpt1_isr);

  NVIC_SET_PRIORITY(IRQ_GPT1, 255); // set priority
  NVIC_ENABLE_IRQ(IRQ_GPT1);        // enable timer IRQ

  CCM_CCGR1 |= CCM_CCGR1_GPT1_BUS(CCM_CCGR_ON); // enable GPT1 module
  GPT1_CR = 0;                                  // disable timer
  GPT1_PR = 23; // prescale: divide by 24 so 1 tick = 1 microsecond at 24MHz
  GPT1_OCR1 = DELAY_MICROSEC - 1;         // compare value
  GPT1_SR = 0x3F;                         // clear all prior status
  GPT1_IR = GPT_IR_OF1IE;                 // use first timer
  GPT1_CR = GPT_CR_EN | GPT_CR_CLKSRC(1); // set to peripheral clock (24MHz)
}
