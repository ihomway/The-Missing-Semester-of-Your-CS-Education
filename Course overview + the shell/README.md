# Course overview + the shell

Website: [English](https://missing.csail.mit.edu/2020/course-shell/), [Chinese](https://missing-semester-cn.github.io/2020/course-shell/)
Video: [Youtube](https://youtu.be/Z56Jmr9Z34Q), [bilibili](https://www.bilibili.com/video/BV1x7411H7wa?p=1)

## Date
Presents the date and the time .

```sh
date
# Sun Dec 27 17:16:07 CST 2020
```

## Echo
Prints out the argument.

```sh
echo hello
# hello
```

## Directory

- `~` is expanded to the home directory;
- `-` is expanded to the previous directory
- `.` means the current directory
- `..` means the parent directory

## drwxrwxrwx

- **d**: stands for directory
- **r**: means you are allowed to read (you can read this file or files in this directory)
- **w**: means you are allowed to write (you can modify this file or create, remove and rename files in the directory)
- **x**: means you are allowed to execute (you can execute this file or enter this directory)
- The first group of three are permissions set for the user owner of the file. The second group of the three are permissions set for the group that owns this file. The last group of three are permissions set for everyone else.

### `#!/bin/sh`
- `#`: starts a comment in Bash
- `!`: has a special meaning

## Exercises
1. Make sure you're running an appropriate shell:
    
    ```sh
    $ echo $SHELL
    /usr/local/bin/fish
    ```
2. Create a new directory called `missing` under `/temp`.
    
    ```sh
    $ mkdir /tmp/missing
    ```

3. Look up the `touch` program. The `man` program is your friend.
    
    ```sh
    $ man touch
    ```
    
4. Use `touch` to create a new file called `semester` in `missing`
    
    ```sh
    $ touch /tmp/missing/semester
    # or
    $ cd /tmp/missing && touch semester
    ```

5. Write the following into that file.
    
    ```sh
    #!/bin/sh
    curl --head --silent https://missing.csail.mit.edu
    ```
    
    ```sh
    echo '#!/bin/sh' >> semester
    echo "curl --head --silent https://missing.csail.mit.edu" >> semester
    ```

*Reference: what is [Bash history expansion](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#History-Interaction) and [how to get rid of it](https://stackoverflow.com/a/11816138)*

6. Try to execute the file. Understand why it doesn’t work by consulting the output of ls (hint: look at the permission bits of the file).

    ```sh
    $ ./semester
    fish: The file './semester' is not executable by this user
    $ ls -l
    -rw-r--r--  1 puer  wheel  61 Dec 23 11:26 semester
    ```

    If running `sh`, we only need read access to the file.

7. Run the command by explicitly starting the sh interpreter
    
    ```sh
    $ sh semester
    HTTP/2 200
    server: GitHub.com
    content-type: text/html; charset=utf-8
    last-modified: Tue, 22 Dec 2020 22:27:28 GMT
    access-control-allow-origin: *
    etag: "5fe272d0-1e7e"
    expires: Wed, 23 Dec 2020 01:47:57 GMT
    cache-control: max-age=600
    x-proxy-cache: MISS
    x-github-request-id: 37AA:2DF4:158F00A:1A3E957:5FE29F75
    accept-ranges: bytes
    date: Wed, 23 Dec 2020 03:28:19 GMT
    via: 1.1 varnish
    age: 0
    x-served-by: cache-hkg17929-HKG
    x-cache: HIT
    x-cache-hits: 1
    x-timer: S1608694099.420960,VS0,VE227
    vary: Accept-Encoding
    x-fastly-request-id: eceef4fad43c176b9ae777b8521a100399f211e1
    content-length: 7806
    ```
    
    Reference: 
    - *[Run ./script.sh vs bash script.sh - permission denied](https://unix.stackexchange.com/questions/203371/run-script-sh-vs-bash-script-sh-permission-denied)*
    - [Difference between sh and bash](https://stackoverflow.com/questions/5725296/difference-between-sh-and-bash)
    - [Curl](https://www.geeksforgeeks.org/curl-command-in-linux-with-examples/)

8. Look up the chmod program (e.g. use man chmod).
    
    ```sh
    man chmod
    ```

9. Use chmod to make it possible to run the command ./semester rather than having to type sh semester. How does your shell know that the file is supposed to be interpreted using sh? See this page on the shebang line for more information.
    
    ```sh
    chmod u=rwx,g=rwx,o=rwx semester
    ```
    
    *Reference: [Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))*

10. Use | and > to write the “last modified” date output by semester into a file called last-modified.txt in your home directory.

    ```sh
    date -r semester > last-modified.txt | mv last-modified.txt ~/last-modified.txt
    ```

1. ~~Write a command that reads out your laptop battery’s power level or your desktop machine’s CPU temperature from /sys. Note: if you’re a macOS user, your OS doesn’t have sysfs, so you can skip this exercise.~~
    
    