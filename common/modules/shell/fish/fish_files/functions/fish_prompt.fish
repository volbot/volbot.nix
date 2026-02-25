function fish_prompt
    voltrix
    ##############
    ## ENV DEFS ##
    ##############
    # set exit code and separators to "error" variant
    set -x retc "$red"
    set -x sep '\U000f05e3'
    set -x preflair ' \uff61\u00b0\u25cb'
    set -x postflair '\u25cb\uff61\u00b0 '
    # replace with "success" variant if applicable 
    test $status = 0
    and set retc "$green"
    and set sep '\ue370'
    and set preflair '\uec10 \U0000e370' 
    and set postflair '\U0000e370 \uec10\u00a0'
    # add color data to separators
    set sep (set_color "$retc")$sep(set_color normal)
    set preflair (set_color "$retc")$preflair(set_color normal)
    set postflair (set_color "$retc")$postflair(set_color normal)

    ###############
    ## FUNCTIONS ##
    ###############

    function _print_left
        function _kaomoji_wrapper
            # defaults: ૮(󰉊 ◡‿◡)づ 
            set eyecolor normal
            set -l adorncolor "$magenta"
            set -l adorn '\U000f024a '
            set -l larm '૮'
            set -l rarm 'づ'
            set -l leye '◡'
            set -l reye '◡'
            set -l mouth '‿'
            set -l spell '\ue370\uec10 \ue370'
            # root user: ૮(⬤_⬤)づ 
            if functions -q fish_is_root_user; and fish_is_root_user
                set leye '⬤'
                set reye '⬤'
                set mouth '_'
                set -e adorn
            end
            # errored exit code: ╭(ò_ó)ง] 
            if [ "$argv" != "$green" ]
                set adorncolor "$cyan"
                set adorn '\ue34a'
                set larm '╭'
                set leye 'ò'
                set mouth '_'
                set reye 'ó'
                set rarm 'ง]'
                set spell ' \uff61\u00b0\u25cb'
            end

            # left arm
            set_color normal
            printf "$larm"
            # left body
            printf '('
            # adorn (optional)
            test -n "$adorn"
            and set_color "$adorncolor" 
            and printf "$adorn"
            # left eye
            set_color $eyecolor
            echo -n "$leye"
            # mouth
            set_color normal
            echo -n "$mouth"
            # right eye
            set_color $eyecolor
            echo -n "$reye"
            # right body
            set_color normal
            echo -n ')'
            # right arm
            printf "$rarm"
            # spell
            set_color "$argv"
            printf "$spell"
        end
        # _print_loc_info
        # prints terminal locational info
        function _print_loc_info
            # set user color: red if root, bright "$magenta" otherwise
            set_color -o "$magenta"
            functions -q fish_is_root_user
            and fish_is_root_user
            and set_color -o "$red"

            # print user
            echo -n $USER

            # if SSH, print host
            if test -n "$SSH_CLIENT"
                set_color -o "$lgray"
                echo -n @
                set_color -o "$blue"
                echo -n (prompt_hostname) 
            end

            # print pwd
            set_color -o "$lgray"      
            echo -n ':'
            set_color -o "$cyan"
            echo -n (prompt_pwd)
        end

        set_color "$argv"
        printf "\u256e$sep"
        # kaomoji (pre flair handled by kaomoji's spell)
        _kaomoji_wrapper "$argv"
        # print user/path info
        _magic_prompt_wrapper '' (_print_loc_info)

        # venv section
        set -q VIRTUAL_ENV_DISABLE_PROMPT
        or set -g VIRTUAL_ENV_DISABLE_PROMPT true
        set -q VIRTUAL_ENV
        and _magic_prompt_wrapper V (basename "$VIRTUAL_ENV")

        # git section
        set -q __fish_git_prompt_showupstream
        or set -g __fish_git_prompt_showupstream auto
        set -l prompt_git (fish_git_prompt '%s')
        test -n "$prompt_git"
        and _magic_prompt_wrapper '\uf1d3 ' $prompt_git

        printf "$postflair"
    end

    function _print_right
        printf "$preflair"

        # date
        _magic_prompt_wrapper '' (date +%X)

        # battery
        type -q acpi
        and test (acpi -a 2> /dev/null | string match -r off)
        and _magic_prompt_wrapper B (acpi -b | cut -d' ' -f 4-)

        printf "$postflair"
        set_color "$argv"
        printf "\u256d"
    end

    # _magic_prompt_wrapper <retc> <field_name> <field_value>
    # display wrapper for discrete sections
    function _magic_prompt_wrapper
        set -l field_name $argv[1]
        set -l field_value $argv[2]

        printf "\u00a0$sep "

        # print field name (optional)
        set_color normal
        test -n $field_name
        and printf $field_name:
        # print field value
        set_color -o normal 
        echo -n $field_value

        printf "$sep  "
    end

    # _get_padding <length>
    # returns a string of spaces
    function _get_padding
        set -l space ""
        for i in (seq 1 $argv[1])
            set space " "$space
        end
        set_color -b normal
        printf "$space"
        set_color normal
    end

    ##########
    ## MAIN ##
    ##########

    #################
    ## HEADER LINE ##
    #################
    set -l left (_print_left "$retc")
    set -l right (_print_right "$retc")
    set -l pad (_get_padding (math $COLUMNS - (echo "$left$right" | string length --visible)))

    echo "$left$pad$right" 

    #############
    ## BG JOBS ##
    #############
    for job in (jobs)
        set -l pad2 (_get_padding (math $COLUMNS - (echo \"$job\" | string escape | string length --visible) - 4))
        set_color "$retc"
        echo -n '│ '
        set_color "$red"
        echo -n "$job$pad2"
        set_color "$retc"
        echo ' │'
    end

    #################
    ## PROMPT LINE ##
    #################
    set_color "$retc"
    printf '\u2570\u2500\U000f06c4 '
    set_color -o "$yellow"
    echo -n '$ '
    set_color normal
end
