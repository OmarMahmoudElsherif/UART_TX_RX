# UART_TX_RX

- UART is a communication protocol that uses a single connection to send or receive data from another 
device. For a full duplex connection, two connections are needed between the two devices, each for 
every direction of transmission.

- There are many serial communication protocol as I2C, UART and SPI.
 A Universal Asynchronous Receiver/Transmitter (UART) is a block of 
circuitry responsible for implementing serial communication.
 UART is Full Duplex protocol (data transmission in both directions 
simultaneously)

- Transmitting UART converts parallel data from the master device (eg. 
CPU) into serial form and transmit in serial to receiving UART.
- Receiving UART will then convert the serial data back into parallel data 
for the receiving device.

- When designing a UART receiver, we need to consider sampling using a higher frequency to determine 
the start of the incoming UART frame. This is not usually done between communicating modules in the 
same device. However, when it comes to inter-device communication, connection wires (or traces on a 
PCB) are much more likely to experience interference and possible glitches due to external signals.
In the case of UART receiver, a sampling signal that 16 times the baud rate is usually used by the 
receiver.
- Once the receiver detects the start of a UART frame, it waits for 8 clock periods to sample the middle of 
the incoming bit (to make sure it is not a glitch). Then, we can now sample the incoming data every 16 
clock periods.
