# Stack-Based-Calculator

Description:
The goal of this project was to use a RAM to implement a stack based calculator. This project contains three files the calculator, which is the top level, the memram, and the calculator test. The calculator and RAM are connected via the internal signals. The RAM in this project is implemented as a stack that holds the operands of the calculator. Operands are added and stored in the stack and popped off when they are used for calculation. The stack executes the operations with the mbr register which also hold an operand. This calculator works via a state machine. The state machine contains three buttons: b2 that adds the data to the mbr register, b3 that takes the value in the mbr to the stack, and b4 that pops the value off the stack and execute the operation with the value and mbr and stores it at mbr. The data and the operation is displayed on the switches. The current value is displayed on the hex displays. The states go as follow: "000" waiting for the button to be pressed, "001" b3 is pressed and waiting for the value to write to the RAM, "100" b4 is pressed and waiting to read into RAM, "101" still waiting, "110" stores the RAM to mbr, then "111" waits for all buttons to release and returns the state to "000". This calculator contains the operations addition, subtraction, multiplication, and division.