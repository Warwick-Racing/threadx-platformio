@/**************************************************************************/
@/*                                                                        */
@/*       Copyright (c) Microsoft Corporation. All rights reserved.        */
@/*                                                                        */
@/*       This software is licensed under the Microsoft Software License   */
@/*       Terms for Microsoft Azure RTOS. Full text of the license can be  */
@/*       found in the LICENSE file at https://aka.ms/AzureRTOS_EULA       */
@/*       and in the root directory of this software.                      */
@/*                                                                        */
@/**************************************************************************/
@
@
@/**************************************************************************/
@/**************************************************************************/
@/**                                                                       */
@/** ThreadX Component                                                     */
@/**                                                                       */
@/**   Initialize                                                          */
@/**                                                                       */
@/**************************************************************************/
@/**************************************************************************/
@
@
    .global     teensy_setup_timer
    .global     _tx_thread_system_stack_ptr
    .global     _tx_timer_interrupt
    .global     __tx_SysTickHandler                 @ SysTick
    
    .text 32
    .align 4
    .syntax unified
@/**************************************************************************/
@/*                                                                        */
@/*  FUNCTION                                               RELEASE        */
@/*                                                                        */
@/*    _tx_initialize_low_level                          Cortex-M7/GNU     */
@/*                                                           6.1          */
@/*  AUTHOR                                                                */
@/*                                                                        */
@/*    William E. Lamie, Microsoft Corporation                             */
@/*                                                                        */
@/*  DESCRIPTION                                                           */
@/*                                                                        */
@/*    This function is responsible for any low-level processor            */
@/*    initialization, including setting up interrupt vectors, setting     */
@/*    up a periodic timer interrupt source, saving the system stack       */
@/*    pointer for use in ISR processing later, and finding the first      */
@/*    available RAM memory address for tx_application_define.             */
@/*                                                                        */
@/*  INPUT                                                                 */
@/*                                                                        */
@/*    None                                                                */
@/*                                                                        */
@/*  OUTPUT                                                                */
@/*                                                                        */
@/*    None                                                                */
@/*                                                                        */
@/*  CALLS                                                                 */
@/*                                                                        */
@/*    None                                                                */
@/*                                                                        */
@/*  CALLED BY                                                             */
@/*                                                                        */
@/*    _tx_initialize_kernel_enter           ThreadX entry function        */
@/*                                                                        */
@/*  RELEASE HISTORY                                                       */
@/*                                                                        */
@/*    DATE              NAME                      DESCRIPTION             */
@/*                                                                        */
@/*  05-19-2020     William E. Lamie         Initial Version 6.0           */
@/*  09-30-2020     William E. Lamie         Modified Comment(s), fixed    */
@/*                                            GNU assembly comment, clean */
@/*                                            up whitespace, resulting    */
@/*                                            in version 6.1              */
@/*                                                                        */
@/**************************************************************************/
@VOID   _tx_initialize_low_level(VOID)
@{
    .global  _tx_initialize_low_level
    .thumb_func
_tx_initialize_low_level:
@
@    /* Disable interrupts during ThreadX initialization.  */
@
    CPSID   i  
@
@    /* Set system stack pointer from vector value.  */
@
    LDR     r0, =_tx_thread_system_stack_ptr        @ Build address of system stack pointer
    LDR     r1, =#0xE000ED08                        @ VTOR register
    LDR     r1, [r1]                                @ Pickup address of vector table
    LDR     r1, [r1]                                @ Pickup reset stack pointer
    STR     r1, [r0]                                @ Save system stack pointer
@
@    /* Enable the cycle count register.  */
@
    LDR     r0, =0xE0001000                         @ Build address of DWT register
    LDR     r1, [r0]                                @ Pickup the current value
    ORR     r1, r1, #1                              @ Set the CYCCNTENA bit
    STR     r1, [r0]                                @ Enable the cycle count register
@
@    /* Configure IMX1062 General Purpose Timer  */
@
    BL teensy_setup_timer

@
@    /* Configure handler priorities.  */
@
    LDR     r0, =#0xE000E000                        @ Build NVIC addr 

    LDR     r1, =0x00000000                         @ Rsrv, UsgF, BusF, MemM
    STR     r1, [r0, #0xD18]                        @ Setup System Handlers 4-7 Priority Registers

    LDR     r1, =0xFF000000                         @ SVCl, Rsrv, Rsrv, Rsrv
    STR     r1, [r0, #0xD1C]                        @ Setup System Handlers 8-11 Priority Registers
                                                    @ Note: SVC must be lowest priority, which is 0xFF

    LDR     r1, =0x40FF0000                         @ SysT, PnSV, Rsrv, DbgM
    STR     r1, [r0, #0xD20]                        @ Setup System Handlers 12-15 Priority Registers
                                                    @ Note: PnSV must be lowest priority, which is 0xFF
@
@    /* Return to caller.  */
@
    BX      lr
@}
@


@ /* System Tick timer interrupt handler */
    .global  __tx_SysTickHandler
    .thumb_func
__tx_SysTickHandler:
    .thumb_func
    PUSH    {r0, lr}
#ifdef TX_ENABLE_EXECUTION_CHANGE_NOTIFY
    BL      _tx_execution_isr_enter             @ Call the ISR enter function
#endif
    BL      _tx_timer_interrupt
#ifdef TX_ENABLE_EXECUTION_CHANGE_NOTIFY
    BL      _tx_execution_isr_exit              @ Call the ISR exit function
#endif
    POP     {r0, lr}
    BX      LR
