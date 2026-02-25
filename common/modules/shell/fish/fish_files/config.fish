if status is-interactive
    #    voltrix 

    # set options for manpage reading
    export MANPAGER="less -R --use-color -Dd+r -Du+b"
    export MANROFFOPT="-P -c"

    fish_vi_key_bindings

    # enable ssh agent
    fish_ssh_agent
    # set alias for config repo management
    alias config='/usr/bin/git --git-dir=/home/alli/.cfg/ --work-tree=/home/alli'
    alias demucs='/home/alli/.local/bin/demucs --shifts=4 -o /neptune/audiostuff/samples/stems/demucs'
    # source local path
    export PATH="$PATH:/home/alli/.local/bin"
end
