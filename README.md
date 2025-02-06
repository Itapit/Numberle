# Numblere - Mathematical Guessing Game

## Overview
Numblere was my **first-ever project**, a high school project I worked on in **2022**, built using **Assembly (8086)**. This game is a **mathematical guessing game**, inspired by Wordle, but with **equations instead of words**. Players must guess the correct mathematical equation using numbers and operators while receiving **color-coded feedback** on their guesses.


## Features
- **Mathematical Guessing Gameplay**:
  - Players attempt to guess a **random equation**.
  - Feedback colors indicate correct/misplaced numbers and operators.
  - Equations follow specific rules (e.g., exactly one '=', no remainder in division).

- **Graphical User Interface (GUI)**:
  - **VGA Mode (13h)** for graphical rendering.
  - **Mouse-based input** using **interrupt 33h**.
  - **Keyboard support** for confirmation.
  
- **Random Equation Selection**:
  - Equations are **randomly selected** from a predefined list.
  - Uses the **BIOS timer (interrupt 1Ah, 40h:6Ch) for randomization**.

- **Win/Loss Handling**:
  - Players have a **limited number of attempts**.
  - Displays **victory or defeat screens**.
  - Option to **restart or exit** after finishing a round.

---

## Installation & Setup
To run Numblere, follow these steps:

### 1. Install DOSBox
Numblere runs in a **DOS environment**. Install **DOSBox** on your system:
- [Download DOSBox](https://www.dosbox.com/download.php?main=1)

### 2. Compile the Assembly Code
You need **TASM (Turbo Assembler) and TLINK (Turbo Linker)** to compile the game.

1. Open **DOSBox** and navigate to the directory where `Numblere.asm` is located.
2. Run the following commands to assemble and link the file:
   ```dos
   tasm Numblere.asm
   tlink Numblere.obj
   ```

### 3. Run the Game
Once compiled, run the game using:
```dos
Numblere.exe
```
This will launch the graphical game interface inside DOSBox.

---

## Gameplay Rules
1. **Each guess must be a valid mathematical equation**.
2. **Operators must be placed correctly** (e.g., no consecutive operators, must have one `=`).
3. **Numbers must be positive integers**.
4. **No remainder in division** (integer division only).
5. **Feedback colors**:
   -  **Green** = Correct number in the correct place.
   -  **Yellow** = Number exists but is misplaced.
   -  **Black** = Number/operator does not exist in the equation.

---

## Controls
- **Mouse Click**: Select numbers and operators.
- **Enter**: Submit the equation.
- **Delete**: Clear the current input.
- **Y**: Play again after winning/losing.
- **N**: Exit the game.

---

## File Structure
```
├── Numblere.asm   # Assembly source code
├── Numblere.exe   # Compiled executable (generated after running TLINK)
├── Numblere.obj   # Object file (generated after running TASM)
```

---

## Contact
For any questions or feedback, feel free to reach out!

