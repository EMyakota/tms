
#!/bin/bash
if [["$@" -eq 0]]; then
        for arg in "$@"; do
                echo "$arg"
                echo "$arg" > arguments.txt
        done
else 
        echo "Please, give me arguments"
fi
