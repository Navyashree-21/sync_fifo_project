# Synchronous FIFO Design using Verilog

## Overview

This project implements a **parameterized Synchronous FIFO (First In First Out)** in **Verilog HDL**.
The FIFO supports **write**, **read**, **full**, and **empty** operations using a **single clock domain**.

This project helps in understanding:

* FIFO memory architecture
* Circular buffer operation
* Read/Write pointer management
* Full/Empty flag generation
* RTL design and verification in Verilog

---

## Features

* Parameterized **data width**
* Parameterized **FIFO depth**
* Supports **write operation**
* Supports **read operation**
* **Full flag** generation
* **Empty flag** generation
* **Count output** for FIFO occupancy tracking
* Handles **simultaneous read and write**
* Includes **Verilog testbench** for verification

---

## Block Diagram

```text
                +----------------------+
data_in   ----> |                      |
wr_en     ----> |   SYNCHRONOUS FIFO   | ----> data_out
rd_en     ----> |                      |
clk       ----> |                      |
rst       ----> |                      |
                +----------------------+
                      |        |
                    full      empty
```

---

## FIFO Specifications

| Parameter     | Value                      |
| ------------- | -------------------------- |
| Data Width    | 8 bits                     |
| FIFO Depth    | 16                         |
| Address Width | 4 bits                     |
| Clock Type    | Single Clock (Synchronous) |

---

## Project Structure

```text
sync_fifo_project/
│
├── rtl/
│   └── sync_fifo.v
│
├── tb/
│   └── sync_fifo_tb.v
│
├─── sync_fifo_waveform.png
│
└── README.md
```

---

## Inputs and Outputs

### Inputs

| Signal    | Width | Description        |
| --------- | ----- | ------------------ |
| `clk`     | 1     | System clock       |
| `rst`     | 1     | Asynchronous reset |
| `wr_en`   | 1     | Write enable       |
| `rd_en`   | 1     | Read enable        |
| `data_in` | 8     | Input data to FIFO |

### Outputs

| Signal     | Width | Description                       |
| ---------- | ----- | --------------------------------- |
| `data_out` | 8     | Output data from FIFO             |
| `full`     | 1     | FIFO full flag                    |
| `empty`    | 1     | FIFO empty flag                   |
| `count`    | 5     | Number of elements stored in FIFO |

---

## Working Principle

### Write Operation

When `wr_en = 1` and FIFO is **not full**:

* `data_in` is stored into FIFO memory
* `write pointer` increments
* `count` increments

### Read Operation

When `rd_en = 1` and FIFO is **not empty**:

* data is read from FIFO memory
* `read pointer` increments
* `count` decrements

### Full Condition

FIFO is **full** when:

```verilog
count == DEPTH
```

### Empty Condition

FIFO is **empty** when:

```verilog
count == 0
```

### Simultaneous Read and Write

If both `wr_en` and `rd_en` are asserted together:

* one data is written
* one data is read
* FIFO `count` remains unchanged

---

## Design Details

The FIFO is implemented using:

* **Memory array** for data storage
* **Write pointer** to track next write location
* **Read pointer** to track next read location
* **Counter** to monitor FIFO occupancy

This FIFO behaves like a **circular buffer**, where pointers wrap around automatically after reaching the last location.

---

## Verification

A dedicated **testbench** (`sync_fifo_tb.v`) was created to verify FIFO functionality.

### Test Cases Covered

* Reset operation
* Write multiple data values
* Read multiple data values
* FIFO Full condition
* FIFO Empty condition
* Simultaneous read and write

---

## Simulation Results

### Observed Behavior

* FIFO correctly stores input data
* FIFO outputs data in **First In First Out** order
* `count` increases during write operations
* `count` decreases during read operations
* `full` flag asserts when FIFO reaches maximum capacity
* `empty` flag asserts when FIFO becomes empty
* Simultaneous read/write operation works correctly

---

## Example Data Flow

### Written Data

```text
10, 20, 30, 40, 50
```

### Read Data

```text
10, 20, 30
```

This confirms correct FIFO functionality:

> First data written is the first data read.

---



## Tools Used

* **Verilog HDL**


---

## Applications

Synchronous FIFO is commonly used in:

* Data buffering
* Processor pipelines
* UART internal buffering
* Streaming systems
* Temporary storage between producer and consumer modules

---

## Future Improvements

This project can be extended to:

* **Asynchronous FIFO**
* **UART + FIFO Integration**
* **APB/AXI Interface FIFO**
* **SystemVerilog Assertions (SVA)**
* **Functional Coverage**

---

## Learning Outcome

Through this project, I learned:

* FIFO architecture and operation
* Pointer-based memory access
* Full/Empty flag generation
* Writing reusable parameterized RTL
* Creating a Verilog testbench
* Waveform-based verification

---


