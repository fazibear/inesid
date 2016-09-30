# ASID
## SidStation MIDI SysEx data protocol

interpretation by
Jouni Paulus, jobe(a)iki.fi, 19.12.2003
rev 2, 20.12.2003

###  start playing
```
F0 2D 4C F7
```

### stop playback
```
F0 2D 4D F7
```

### display characters on LCD
```
F0 2D 4F charseq F7
```
- `charseq`: `char*` (zero or more chars)
- `char`:    ASCII_CODE bitwise_and 7F

#### send command to SID
```
F0 2D 4E command 7F
```
- `command`: `mask1``mask2``mask3``mask4``msb1``msb2``msb3>``msb4``data`
- `maskX`: in this byte the bit number "id" is set for write to the corresponding reg according to the table below, e.g. write to regs 0 and 1 and not to 2,3,5,6,7 causes the `mask1` to be "000011" = 0x03 etc (N1)
- `msbX`: similarly to `maskX`, containing the MSB (8th bit) of the data to be written to the corresponding register. - `data`: actual data for the registers each byte containing the 7 lowest bits of the data byte data bytes are sent only for the registers that have been indicated in the `maskX` bytes, i.e. in binary representation the number of 1-bits in all 4 mask bytes is equal to the numbers of bytes in `data` (NB2)

NB: If two consecutive writes occure to the registers 0x04, 0x0B or 0x12 within on sent frame, the second write will be indicated as writes to the registers 0x19, 0x1A and 0x1B. This is probably due to some timing matters.

NB2: There is still some things to be cleared with the writes to filter registers, 0x15 and 0x16.

| id  | reg | hex | info |    
|-----|-----|-----|------|
| 00  | 00  | 00  | LSB
| 01  | 01  | 01
| 02  | 02  | 02
| 03  | 03  | 03
| 04  | 05  | 05
| 05  | 06  | 06
| 06  | 07  | 07  | MSB
|
| 07  | 08  | 08  | LSB
| 08  | 09  | 09
| 09  | 10  | 0A
| 10  | 12  | 0C
| 11  | 13  | 0D
| 12  | 14  | 0E
| 13  | 15  | 0F  | MSB
|     
| 14  | 16  | 10  | LSB
| 15  | 17  | 11
| 16  | 19  | 13
| 17  | 20  | 14
| 18  | 21  | 15
| 19  | 22  | 16
| 20  | 23  | 17  | MSB
|
| 21  | 24  | 18  | LSB
| 22  | 04  | 04
| 23  | 11  | 0B
| 24  | 18  | 12
| 25  | 25  | 19  | <= secondary for reg 04
| 26  | 26  | 1A  | <= secondary for reg 11
| 27  | 27  | 1B  | <= secondary for reg 18 MSB
