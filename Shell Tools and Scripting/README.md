# Shell Tools and Scripting

Website: [English](https://missing.csail.mit.edu/2020/shell-tools/), [Chinese](https://missing-semester-cn.github.io/2020/shell-tools/)
Video: [Youtube](https://youtu.be/kgII-YWo3Zw), [bilibili](https://www.bilibili.com/video/BV1x7411H7wa?p=2)

## Variable
```sh
# Assign
foo=bar
# Access
$foo
```

`foo = bar` will not work since it is interpreted as calling the `foo` program with arguments `=` and `bar`. (In shell scripts the space character will perform argument splitting.)

## String
- `'`: strings delimited with `'` are literal strings and will not substitute variable values;
- `"`: strings delimited with `"` will substitute variable values.

```sh
foo=bar
echo "$foo"
# bar
echo '$foo'
# $foo
```

## Control flow
`if`, `case`, `while`, `for`

## Function

```sh
# `$1` is the first argument
mcd () {
    mkdir -p "$1"
    cd "$1"
}
```

- `$0`: name of the script
- `$1` to `$9`: arguments to the script. `$1` is the first argument and so on
- `$@`: all the arguments
- `$#`: number of arguments
- `$?`: return code of the previous command
- `$$`: process identification number (PID) for the current script
- `!!`: entire last command, including arguments. A common pattern is to execute a command only for it to fail due to missing permissions; you can quickly re-execute the command with `sudo` by doing `sudo !!`
- `$_`: last argument from the last command. If you are in an interactive shell, you can also quickly get this value by typing `Esc` followed by `.`

*A more comprehensive list can be found [here](https://www.tldp.org/LDP/abs/html/special-chars.html).*

Commands will often return output using `STDOUT`, errors through `STDERR`, and a *Return Code* to report errors in a more script-friendly manner. A value of `0` usually means everything went *OK*; anything different from `0` means an error occurred.

## Conditionally execute
- `&&` (and): second command will be executed only when first command went *OK*;
- `||` (or): second command will be executed only when first command went *Wrong*;
- `;`: second command will be executed no matter how the first command went;
- `$( CMD )`: it will execute `CMD`, get the output of the command and substitude it in place.
- `<( CMD )`: will execute `CMD` and place the output in a temporary file and substitute the `<()` with the file's name.

`&&` and `||` are both [short-circuiting](https://en.wikipedia.org/wiki/Short-circuit_evaluation) operators.

```sh
false || echo "Oops, fail"
# Oops, fail

true || echo "Will not be printed"
#

true && echo "Things went well"
# Things went well

false && echo "Will not be printed"
#

true ; echo "This will always run"
# This will always run

false ; echo "This will always run"
# This will always run

for file in $(ls)
# The shell will first call ls and then iterate over those values

diff <(ls foo) <(ls bar)
# Will show differences between files in dirs foo and bar.
```

```sh
#!/bin/bash

echo "Starting program at $(date)"
# Date will be substituded

echo "Running program $0 with $# arguments with pid $$"

for file in "$@"; do
    grep foobar "$file" > /dev/null 2> /dev/null
    # When pattern is not found, grep has exit status 1
    # We redirect STDOUT and STDERR to a null register since we do not care about them
    if [[ $? -ne 0 ]]; then
        echo "File $file does not have any foobar, adding one"
        echo "# foobar" >> "$file"
    fi
done
```

- *You can find a detail list about comparions in the mapage for [test](https://www.man7.org/linux/man-pages/man1/test.1.html)*.
- When performing comparisons in bash, try to use double brackets `[[ ]]` in favor of simple brackets `[ ]`. Explanation can be found [here](http://mywiki.wooledge.org/BashFAQ/031).

## Shell globbing

- wildcards: you can use `?` and `*` to match one or any amount of characters respectively.
- Curly bareces `{}`: you can use curly braces for bash to expand a commaon substring in a series of commands.

```sh
convert image.{png,jpg}
# Will expand to
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# Will expand to
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# Globbing techniques can also be combined
mv *{.py,.sh} folder
# Will move all *.py and *.sh files

mkdir foo bar
# This creates files foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h
touch {foo,bar}/{a..h}
touch foo/x bar/y
# Show differences between files in foo and bar
diff <(ls foo) <(ls bar)
# Outputs
# < x
# ---
# > y
```

## Shellcheck

Use [shellcheck](https://github.com/koalaman/shellcheck) to help you find errors in your sh/bash script.

## Differences between functions and scripts

- Functions have to be in the same language as the shell, while scripts can be written in any language. This is why including a shebang for scripts is important.
- Functions are loaded once when their definition is read. Scripts are loaded every time they are executed. This makes functions slightly faster to load, but whenever you change them you will have to reload their definition.
- Functions are executed in the current shell environment whereas scripts execute in their own process. Thus, functions can modify environment variables, e.g. change your current directory, whereas scripts can’t. Scripts will be passed by value environment variables that have been exported using export
- As with any programming language, functions are a powerful construct to achieve modularity, code reuse, and clarity of shell code. Often shell scripts will include their own function definitions.

## Shell Tools

Command | Usage | Notes
--------|-------|------
`man` | `man ls` | provides a manual page for a command
[`tldr`](https://tldr.sh) | `tldr ls` | focuses on giving example use cases of a command
`find` | `find . -name src -type d` | recursively search for files
[`fd`](https://github.com/sharkdp/fd) | `fd PATTERN` | simple, fast and user-friendly
`locate` | `locate foo` | quickly searching
`grep` | `grep -C 5` | matching patterns from the input text
[`ack`](https://beyondgrep.com/) | | a `grep` alternative
[`ag`](https://github.com/ggreer/the_silver_searcher) | | a `grep` alternative
[`rg`](https://github.com/BurntSushi/ripgrep) | `rg foo -A 5` | a `grep` alternative
`history` | `history | grep find` | access your shell history prorgrammaticallly
[`fasd`](https://github.com/clvv/fasd) |  | ranks files and directories by [frecency](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/Places/Frecency_algorithm)
`autojump` | | 
`tree` | `tree .` | get an overview of a directory structure
`broot` | `broot .` | get an overview of a directory structure

*`find` has a property can be incredibly helpful to simplify what could be fairly monotonous tasks*

```sh
# Delete all files with .tmp extension
find . -name '*.tmp' -exec rm {} \;
# Find all PNG files and convert them to JPG
find . -name '*.png' -exec convert {} {}.jpg \;
```

## Exercises
1. Read `man ls` and write an `ls` command that lists files in the following manner:
    - Includes all files, including hidden files
    - Sizes are listed in human readable format (e.g. 454M instead of 454279954)
    - Files are ordered by recency
    - Output is colorized
    - A sample output would look like this
        
        ```sh
        -rw-r--r--   1 user group 1.1M Jan 14 09:53 baz
        drwxr-xr-x   5 user group  160 Jan 14 09:53 .
        -rw-r--r--   1 user group  514 Jan 14 06:42 bar
        -rw-r--r--   1 user group 106M Jan 13 12:12 foo
        drwx------+ 47 user group 1.5K Jan 12 18:08 ..
        ```
    
    ```sh
    ls -aGhlt .
    ```
    
2. Write bash functions `marco` and `polo` that do the following. Whenever you execute `marco` the current working directory should be saved in some manner, then when you execute `polo`, no matter what directory you are in, `polo` should cd you back to the directory where you executed `marco`. For ease of debugging you can write the code in a file *marco.sh* and (re)load the definitions to your shell by executing `source marco.sh`.

    ```sh
    #!/usr/bash

    marco () {
        marco_dir=$(pwd)
    }

    polo () {
        cd "$marco_dir"
    }
    ```

3. Say you have a command that fails rarely. In order to debug it you need to capture its output but it can be time consuming to get a failure run. Write a bash script that runs the following script until it fails and captures its standard output and error streams to files and prints everything at the end. Bonus points if you can also report how many runs it took for the script to fail.

    ```sh
    #!/usr/bin/env bash

    n=$(( RANDOM % 100 ))

    if [[ n -eq 42 ]]; then
        echo "Something went wrong"
        >&2 echo "The error was using magic numbers"
        exit 1
    fi
    
    echo "Everything went according to plan"
    ```

    ```sh
    #!/usr/bash

    cnt=0

    until [[ $STATUS -eq 1 ]]
    do
	   ./fail.sh >> log.txt 2>&1
	   STATUS=$?
	   cnt=$(( cnt+1 ))
    done

    echo "It took $cnt times to fail"
    ```
    
4. As we covered in the lecture find’s `-exec` can be very powerful for performing operations over the files we are searching for. However, what if we want to do something with all the files, like creating a zip file? As you have seen so far commands will take input from both arguments and **STDIN**. When piping commands, we are connecting **STDOUT** to **STDIN**, but some commands like `tar` take inputs from arguments. To bridge this disconnect there’s the `xargs` command which will execute a command using `STDIN` as arguments. For example `ls | xargs rm` will delete the files in the current directory. Your task is to write a command that recursively finds all HTML files in the folder and makes a zip with them. Note that your command should work even if the files have spaces (hint: check -d flag for xargs). If you’re on macOS, note that the default BSD find is different from the one included in GNU coreutils. You can use -print0 on find and the -0 flag on xargs. As a macOS user, you should be aware that command-line utilities shipped with macOS may differ from the GNU counterparts; you can install the GNU versions if you like by using brew.

    ```sh
    find *.html -print0 | xargs -0 tar czf target.tar.gz
    ```

5. (Advanced) Write a command or script to recursively find the most recently modified file in a directory. More generally, can you list all files by recency?

    ```sh
    # list all files by recency
    ls -lRt
    ```
    
    ```sh
    find . -type f | xargs ls -lt | head -n 1
    ```

