# APB UART

First Spinal Project  
Just For Learning Spinal  

## IO Map:
    0x0 State&Config Register
        27-26          25          24        23-20               19-16                  9         8           7-4               3-0
        Access Width   Byte Order  Over Run  TX FIFO Threshold   RX FIFO Threshold      TX busy   RX busy     TX FIFO Count     RX FIFO Count
        
        Access Width
            0: Access in 1Byte Mode
            1: Access in 2Byte Mode
            3: Access in 4Byte Mode
        Byte Order
            When Access Width > 0, Determines Big-Endian or Little-Endian
        Over Run
            Go to 1 when RX overflows
            Write 0 to Clear

    0x4 Clock Divider
        The UART Baudrate = Clock Frequency / (8 * Clock Divider)
        The Width of Clock Divider is 16bit

    0x8 TX
        Write When Full Will Cause Blocking
    0xC RX
        Read When Empty Will Cause Blocking

## Interrupt Signal:
    TX_FIFO_Empty
        High When Count of TX_FIFO is Smaller than TX Threshold
    RX_FIFO_Full
        High When Count of RX_FIFO is Larger than RX Threshold
