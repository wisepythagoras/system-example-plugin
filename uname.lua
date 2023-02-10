fmt = import('fmt')

function get_flags()
    flags = newBoolMap()
    flags['--help'] = false
    flags['-a'] = false
    flags['--all'] = false
    flags['-s'] = false
    flags['--kernel-name'] = false
    flags['-n'] = false
    flags['--nodename'] = false
    flags['-r'] = false
    flags['--kernel-release'] = false
    flags['-v'] = false
    flags['--kernel-version'] = false
    flags['-m'] = false
    flags['--machine'] = false
    flags['-p'] = false
    flags['--processor'] = false
    flags['-i'] = false
    flags['--hardware-platform'] = false
    flags['-o'] = false
    flags['--operating-system'] = false
    flags['--version'] = false
    flags['--help'] = false

    return flags
end

function uname_command(args, session)
    flags = get_flags()
    opts, raw, err = args:ParseOpts(flags)

    fmt.Println(opts, err)
end
