ENTRY(_start)

SECTIONS
{
  /* Instructions and constants start at 0x0000 */
  .text 0x00000000 :
  {
    *(.text._start)  /* Place _start at beginning */
    *(.text*)        /* All code */
    *(.rodata*)      /* Read-only data like const strings */
  }

  /* Global data starts at 0x0200 */
  .data 0x00000200 :
  {
    *(.data*)
  }

  /* BSS follows data (auto-placement) */
  .bss :
  {
    __bss_start = .;
    *(.bss*)
    *(COMMON)
    __bss_end = .;
  }
}
