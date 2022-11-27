# macOS Permission Denied issue - resolved

## Reference

* [Stack Overflow post](https://stackoverflow.com/questions/72123620/permission-denied-when-i-am-trying-to-add-julia-to-path-in-macos/72308646#72308646)

## Question by Mahdi:

I have installed Julia 1.7 on my macOS and because I cannot call it directly from the terminal, I want to add it to the path, for this aim, I am using the following command

```bash
ln -s /Applications/Julia-1.7.app/Contents/Resources/julia/bin/julia /usr/local/bin/julia
```

The result is however permission denied.

Does anybody have a solution?

Cheers

## Answer by Chad:

I also installed Julia 1.7 on my macOS but could NOT call it directly from the terminal. I found `/usr/local/bin` that the symbolic link was pointing the julia folder:

```bash
lrwxr-xr-x   1 root  wheel   52 Apr  5 17:25 julia -> /Applications/Julia-1.7.app/Contents/Resources/julia
```

and not to the actual julia binary file. (By the way, in the `/Applications/Julia-1.7.app/Contents/Resources/julia` folder, I also found an existing symbolic link `julia -> /Applications/Julia-1.7.app/Contents/Resources/julia/bin/julia`, but I am unsure if this was working.)

So I did this update:

```bash
% cd /usr/local/bin
% sudo rm -i julia
remove julia? y
```

to remove the existing link, then recreated a link to the julia file (not, as previous, the julia folder):

```bash
% sudo ln -s /Applications/Julia-1.7.app/Contents/Resources/julia/bin/julia /usr/local/bin/julia
```

which shows:

```bash
% ls -l
lrwxr-xr-x  1 root  wheel  62 May 19 10:53 julia -> /Applications/Julia-1.7.app/Contents/Resources/julia/bin/julia
```

and now I CAN call Julia 1.7 on my macOS directly from my terminal, as desired:

```bash
% julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.7.2 (2022-02-06)
 _/ |\__'_|_|_|\__'_|  |  HEAD/bf53498635 (fork: 461 commits, 344 days) 
|__/                   |

julia>
```