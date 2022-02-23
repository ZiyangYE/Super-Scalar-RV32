# Instruction cache

## Configuration:
    readPortCount
        The width of the icache to the instruction fetch unit
        Counted in 32bits.
        E.g. 
            1 => readPort Width=32bits
            2 => readPort Width=64bits
    memPortWidth
        The width of the ROM part
    memSize
        The size of the ROM, counted in byte
    memAdrOffset
        Code section offset
        E.g.
            Code start from 0x1000_0000 in the system level, and start from 0x0000_0000 in the ROM
                ==>The offset should be 0xF000_0000
            Code start from 0x0000_0000 in the system level, and start from 0x0000_1000 in the ROM
                ==>The offset shoule be 0x0000_1000
    partCount,
        The count of the cache part
        Larger would increase the hit rate with multiple branch instructions, but consumes more resources and decrease the Fmax
    partSize
        The size of a single cache part
        Larger would increse the hit rate with longer code part, but consumes more resources

## IO Interface:
    readData[O]
        The cache data to the instruction fetch unit
        Width = 32*readPortCount bits
    readValid[O]
        The sign of the valid in the readDate port
        Width = readPortCount bits
        Each bit stands for the validity of 32 bits
    readAddr[I]
        The address of the first 32bits in the readData port
        Width = 32 bits

    memFlow[S]
        The flow from the ROM interface
        Width = memPortWidth
    memAddr[O]
        The address to be read from the ROM
        Width = log2up(memSize)
