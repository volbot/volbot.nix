function fish_greeting
    ###############
    ## FUNCTIONS ##
    ###############
    # _print_line <i> <message> <fish>
    # prints <message> surrounded by <fish> with indexed (0,1) flair
    function _print_line
        set -l line "$argv[3]   $argv[2]   $argv[3]"

        # set to flair 0
        set -l preflair  '\u256E'
        set -l postflair '\u256D'
        # replace with flair 1 if applicable
        if [ $argv[1] = 1 ]
            set preflair  '\u256F'
            set postflair '\u2570'
        end

        # get full padsize
        set -l padsize (math $COLUMNS - (echo "$line" | string length --visible) - 2)
        # divide with floor and ceil
        set -l pad1 (_get_padding (math ceil \($padsize / 2\)))
        set -l pad2 (_get_padding (math floor \($padsize / 2\)))

        # print line with flair and padding
        set_color "$green"
        printf "$preflair"
        set_color normal
        printf "$pad2$line$pad1"
        set_color "$green"
        printf "$postflair"
        echo
    end

    # _get_padding <length>
    # returns a string of spaces
    function _get_padding
        set -l space ""
        for i in (seq 1 $argv[1])
            set space " "$space
        end
        set_color -b normal 
        printf $space
        set_color normal
    end

    ##########
    ## MAIN ##
    ##########

    # define unicode fish
    set tuna (
    set_color -o "$red" 
    echo -n '>°'
    set_color -o "$blue"
    echo -n '))))'
    set_color -o "$dgray" 
    echo -n '彡'
    set_color normal
    )
    set marlin (set_color -o "$blue"
    echo -n '>><('
    set_color -o "$lgray"
    echo -n '('
    set_color -o "$white"
    echo -n '('
    set_color -o "$lgray"
    echo -n '・'
    set_color -o "$blue"
    echo -n '>'
    )

    # print both lines
    _print_line 0 'welcome to fish!!'               "$tuna"
    _print_line 1 "today is $(date +"%A, %B %d")!!" "$marlin"
end
