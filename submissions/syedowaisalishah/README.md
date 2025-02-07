# RISC-V Instruction Loader 🏗️  

This repository contains a **RISC-V Instruction Loader** script that:  
- Parses **YAML files** containing instruction definitions  
- Allows **filtering based on instruction extensions**  
- Includes **unit tests** to validate functionality and ensure the integrity of YAML files  

---

## Features 🚀  

✅ Loads all **YAML instruction files** from the `db` directory 📂  
✅ Supports **filtering instructions** by extension(s) 🔍  
✅ Provides **warnings for incorrect YAML formatting** ⚠️  
✅ Uses `Oj` for **fast and efficient JSON/YAML parsing** 🚀  
✅ Uses `Colorize` for **enhanced terminal output** 🎨  
✅ Includes **unit tests** using `Minitest` 🧪  
✅ Displays results with **symbols** ✅ and ❌ for clarity  

---

## Installation 📦  

Ensure you have **Ruby installed**. Then, install necessary dependencies:  

```sh
gem install bundler minitest yaml oj colorize

```

## Usage 📜  

Run the script to load and filter instructions:  

```sh
ruby SubmitTask.rb
```
Enter comma-separated extension names: A, C

### Example Output
Instructions matching extensions ["A", "C"]:
✅ INSTRUCTION 'add' MATCHING ["A"] FOUND IN add.yaml
✅ INSTRUCTION 'mul' MATCHING ["A", "C"] FOUND IN mul.yaml
❌ No matching instructions found for other extensions.

## Running Unit Tests 🧪

```sh
ruby TestRiscvLoader.rb
```
## Unit Tests 🧪  

Unit tests validate:  

✔️ **Proper YAML file loading**  
✔️ **Filtering logic**  
✔️ **YAML file integrity in the `db` directory**  


