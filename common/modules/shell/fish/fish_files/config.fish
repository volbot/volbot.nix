if status is-interactive
    #    voltrix 

    # set options for manpage reading
    export MANPAGER="less -R --use-color -Dd+r -Du+b"
    export MANROFFOPT="-P -c"

    set -gx EDITOR nvim

    fish_vi_key_bindings

    # enable ssh agent
    fish_ssh_agent
end
