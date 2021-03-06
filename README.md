# TramelBlaze_UART_Project

OVERVIEW

The objective of this project is to create a program that can serially receive keystrokes in the form of ASCII code and then transmit those keystrokes in an intuitive user interface. The two key components used in the project will be the Universal Asynchronous Receiver Transmitter (UART) and the TramelBlaze microcontroller.

TRAMELBLAZE

The TramelBlaze is a 16-bit imbedded RISC microcontroller whose architecture is based on Xilinx’s PicoBlazeTM. Like the PicoBlazeTM, the TramelBlaze is a system-on-a-programmable-chip (SoPC). That is, it is a “soft” processor core that can be imbedded onto an FPGA using the FPGA’s existing logic elements. This provides the designer with more flexibility in determining functionality for the microcontroller. Although the TramelBlaze can be adapted to have many different functions, the function of the TramelBlaze in this project is to facilitate the user interface and provide appropriate responses to all keystrokes.

UART

The function of the UART is to convert incoming serial data into parallel data which can be interpreted by the TramelBlaze, and to transmit parallel data from the TramelBlaze in the form of serial data to an external receiver. The UART’s two main modules that achieve the aforementioned functions are its receive engine and transmit engine. The receive engine records the incoming data bit by bit into a shift register, assembling the string of bits into code. In contrast, the transmit engine outputs the bits of code one bit at a time.

TECHNOLOGY

This project is optimized for implementation on a Basys 3 board, which uses an Artix-7 FPGA from Xilinx. The Basys 3 includes enough switches, LEDs, and other I/O devices to allow a large number of designs—including the design of this project— to be completed without the need for any additional hardware.
