function fish_right_prompt

    voltrix 
    # get previous exit code as "$green"/"$red"
    set -x retc "$red"
    test $status = 0; and set retc "$green"

    # pre flair
    set_color $retc
    printf '\U000f0972 \u2500'

    # vim mode viewer (only shown when enabled)
    if test "$fish_key_bindings" = fish_vi_key_bindings
        or test "$fish_key_bindings" = fish_hybrid_key_bindings
        echo -n '['

        set -l mode
        switch $fish_bind_mode
            case default
                set mode (set_color --bold -r "$red")NORMAL
            case insert
                set mode (set_color --bold -r "$yellow")INSERT
            case replace_one
                set mode (set_color --bold -r "$cyan")REPLACE
            case replace
                set mode (set_color --bold -r "$green")REPLACE
            case visual
                set mode (set_color --bold -r "$magenta")VISUAL
        end

        set mode $mode(set_color normal)
        echo -n "$mode"

        set_color $retc
        echo -n ']'
    end

    # post flair
    set_color $retc
    printf '\u2500\u256F'
    set_color normal
end
