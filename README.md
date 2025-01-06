# Challenge

Create a Ruby program that:

1. Loads all the `*.yaml` files found under `db/`
    - The YAML files all represent RISC-V instructions
2. Print the number of files/instructions found
3. Print a warning message for any YAML file where the `name:` key does not exactly match the base filename.
    - Excluding '.yaml'. For example, `name: add` exactly matches the filename `add.yaml`.
4. Asks for a comma-separated list of extension names, and then prints the name of all instructions that are defined by those extensions.

The `definedBy` key captures which extension(s) define an instruction. It can take several forms:

- A string ('Zba'), indicating that the instruction is defined by one and only one extension
- A (possibly nested) hash/map/dictionary indicating that an instructions is defined by one or more extensions. The hash will contain either of the following:
    - `allOf: Array` The instruction is defined if all of the names or nested conditions in the array match
    - `anyOf: Array` The instruction is defined if any of the names or nested conditions in the array match

For example, if an instruction is `definedBy: Zba`, then it is defined if the Zba extension is implemented. If an instruction is `definedBy: { allOf: [F, Zfa] }`, then the instruction is defined *only if both* the F and Zfa extensions are implemented. If an instruction is `definedBy: { anyOf: [B, Zba] }`, then the instruction is defined *if either* the B or Zba extension are implemented. If an instruction is `definedBy: { anyOf: [B, { allOf: [Zba, Zbb] } ] }`, then it is defined if either the B extension is implemented or both the Zba and Zbb extensions are implemented.

# Submission

To submit your entry, create a Pull Request against this repository (https://github.com/dhower-qc/ruby-programming-challenge.git) that:

- Contains your submission in a new directory under `submissions` named after your GitHub username. For example, `submissions/dhower-qc`.
- Contains a ruby script at `submissions/<username>/run.rb` that fufills the requirements above and can be run without needing any command-line parameters
