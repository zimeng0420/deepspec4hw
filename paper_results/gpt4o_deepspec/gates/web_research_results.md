# Web Research Results

Total Results: 1

## Result 1

Here's a breakdown of the functionalities and truth tables for basic logic gates:

**General Concepts**

*   **Truth Table:** A table that represents the Boolean expression of a logic gate function. It displays each possible input combination and the resulting output.
*   **Boolean Algebra:**  The algebraic expression showing the operation of the logic circuit for each input variable (True or False, 1 or 0) that results in a logic "1" output.
*   Logic gates need a power supply to operate. Inputs are driven by two nominal voltage values representing logic 0 and logic 1. The gate output also provides two nominal voltage values, representing logic 0 and logic 1.
*   Logic gates are the building blocks of combinational logic circuits.
*   Any combinational circuit can be implemented with only NAND and NOR gates, as these are "universal" gates.

**1. AND Gate**

*   **Functionality:** The output is HIGH (1) only when all its inputs are HIGH (1).  If any of the inputs are LOW (0), the output is LOW (0). It performs logical multiplication of binary inputs.
*   **Boolean Expression:** A.B = Q  (or AB = Q). The dot (.) signifies logical multiplication.
*   **Truth Table:**

    | Input A | Input B | Output Q |
    | :------ | :------ | :------- |
    | 0       | 0       | 0        |
    | 0       | 1       | 0        |
    | 1       | 0       | 0        |
    | 1       | 1       | 1        |

**2. OR Gate**

*   **Functionality:** The output is HIGH (1) if any of its inputs is HIGH (1). The output is LOW (0) only when all of its inputs are LOW (0). Implements logical disjunction.
*   **Boolean Expression:** A + B = Q. The plus sign (+) denotes the OR operation.
*   **Truth Table:**

    | Input A | Input B | Output Q |
    | :------ | :------ | :------- |
    | 0       | 0       | 0        |
    | 0       | 1       | 1        |
    | 1       | 0       | 1        |
    | 1       | 1       | 1        |

**3. XOR Gate (Exclusive OR)**

*   **Functionality:** The output is HIGH (1) only when the inputs are different. The output is LOW (0) when the inputs are the same. XOR represents the inequality function.
*   **Boolean Expression:**  A ⊕ B
*   **Truth Table:**

    | Input A | Input B | Output Q |
    | :------ | :------ | :------- |
    | 0       | 0       | 0        |
    | 0       | 1       | 1        |
    | 1       | 0       | 1        |
    | 1       | 1       | 0        |

**4. NAND Gate (NOT AND)**

*   **Functionality:** The output is the inverse of an AND gate. It outputs LOW (0) only when all inputs are HIGH (1). It is a universal gate.
*   **Boolean Expression:** ¬(A ⋅ B)  or  (A.B) with a bar over the top.
*   **Truth Table:**

    | Input A | Input B | Output Q |
    | :------ | :------ | :------- |
    | 0       | 0       | 1        |
    | 0       | 1       | 1        |
    | 1       | 0       | 1        |
    | 1       | 1       | 0        |

**5. NOR Gate (NOT OR)**

*   **Functionality:** The output is the inverse of the OR gate. The output is HIGH (1) only if all inputs are LOW (0). It is a universal gate.
*   **Boolean Expression:** ¬(A + B) or (A+B) with a bar over the top.
*   **Truth Table:**

    | Input A | Input B | Output Q |
    | :------ | :------ | :------- |
    | 0       | 0       | 1        |
    | 0       | 1       | 0        |
    | 1       | 0       | 0        |
    | 1       | 1       | 0        |

**6. XNOR Gate (Exclusive NOR)**

*   **Functionality:** The output is HIGH (1) when both inputs are the same (either both 0 or both 1). The output is LOW (0) when the inputs are different. Performs logical equality.
*   **Boolean Expression:** A ⊙ B.
*   **Truth Table:**

    | Input A | Input B | Output Q |
    | :------ | :------ | :------- |
    | 0       | 0       | 1        |
    | 0       | 1       | 0        |
    | 1       | 0       | 0        |
    | 1       | 1       | 1        |

**7. AND-NOT Gate**

*   Also known as an Inhibit gate. The AND-NOT gate performs the AND operation and then inverts one of the inputs.
*   **Functionality**: The output is HIGH only if A is HIGH and B is LOW.
*   **Boolean Expression**: A AND (NOT B) which can be written as A * ¬B
*   **Truth Table:**

    | Input A | Input B | Output Q |
    | :------ | :------ | :------- |
    | 0       | 0       | 0        |
    | 0       | 1       | 0        |
    | 1       | 0       | 1        |
    | 1       | 1       | 0        |


---

