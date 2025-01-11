# Ruby Programming Submission
This directory contains the Ruby program submission.

## How to run the program

The script is found in the file named `run.rb`

It can be run on the terminal as `ruby run.rb` or `./run.rb`

## Output

When running the script, the output are as follows

### Default output

This is the output when the user does not add the list of comma-separated list of extensions and instead presses Enter.

The output will be as below

```
the number of yaml files/instructions are 1145
fmadd.d does not match fmadd.h which is found at ~/lfx-pretasks/ruby-programming-challenge/db/Zfh/fmadd.h.yaml
Enter list of extensions , separated by commas to get instructions/yaml files that implement them.
If you don't want to search for files with the input extensions press enter to close program: 
Thank you for using our program. Execution ends here
```

### Output with list of extensions 

This is the output of the script when a user adds a list of comma-separated extensions

Say a user enters `Svinval` when prompted for extensions, the output will be as below
```
the number of yaml files/instructions are 1145
fmadd.d does not match fmadd.h which is found at ~/lfx-pretasks/ruby-programming-challenge/db/Zfh/fmadd.h.yaml
Enter list of extensions , separated by commas to get instructions/yaml files that implement them.
If you don't want to search for files with the input extensions press enter to close program: Svinval
Your list of extensions is: ["Svinval"]
Yaml file with extension ["Svinval"] also has the following extensions Svinval and is found at ~/lfx-pretasks/ruby-programming-challenge/db/Svinval/sfence.w.inval.yaml
Yaml file with extension ["Svinval"] also has the following extensions Svinval and is found at ~/lfx-pretasks/ruby-programming-challenge/db/Svinval/sfence.inval.ir.yaml
Yaml file with extension ["Svinval"] also has the following extensions Svinval and is found at ~/lfx-pretasks/ruby-programming-challenge/db/Svinval/sinval.vma.yaml
```

Say a user enters `B,ZK` when prompted for extensions, the output will be as below
```
the number of yaml files/instructions are 1145
fmadd.d does not match fmadd.h which is found at ~/lfx-pretasks/ruby-programming-challenge/db/Zfh/fmadd.h.yaml
Enter list of extensions , separated by commas to get instructions/yaml files that implement them.
If you don't want to search for files with the input extensions press enter to close program: B,Zk
Your list of extensions is: ["B", "Zk"]
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbkb", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/Zbkb/zip.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbkb", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/Zbkb/unzip.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbkb", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/Zbkb/brev8.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbb", "Zbkb", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/B/orn.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbb", "Zbkb", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/B/rori.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbc", "Zbkc", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/B/clmul.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbc", "Zbkc", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/B/clmulh.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbb", "Zbkb", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/B/ror.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbb", "Zbkb", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/B/rol.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbb", "Zbkb", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/B/rorw.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbb", "Zbkb", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/B/andn.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbb", "Zbkb", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/B/roriw.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbb", "Zbkb", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/B/xnor.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbb", "Zbkb", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/B/rolw.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbkx", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/Zbkx/xperm8.yaml
Yaml file with extension ["B", "Zk"] also has the following extensions {"anyOf"=>["B", "Zbkx", "Zk", "Zkn", "Zks"]} and is found at ~/lfx-pretasks/ruby-programming-challenge/db/Zbkx/xperm4.yaml
```

## Caveats of the program
This script is simple and does not use functions.

It uses relative paths and not explicit file paths.
