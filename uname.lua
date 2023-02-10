fmt = import('fmt')
strings = import('strings')

local kernel_name = 'Linux'
local kernel_release = '5.15.84-v7+'
local kernel_version = '#1613 SMP Thu Jan 5 11:59:48 GMT 2023'
local machine = 'armv7l'
local processor = 'unknown'
local hardware_platform = 'unknown'
local operating_system = 'GNU/Linux'

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
    flags:Test()

    return flags
end

function uname_command(args, session)
    flags = get_flags()
    opts, raw, err = args:ParseOpts(flags)

    if err ~= nil then
        session:TermWrite(err:String())
    end

    out = ''
    hostname = 'rpi'

    _, h, err = session.VFS:FindFile('/etc/hostname')

    if err == nil then
        hostname = strings.Trim(h.Contents, '\n')
    end

    if opts['a'] or opts['all'] then
        out = fmt.Sprintf(
            '%s %s %s %s %s %s\n',
            kernel_name,
            hostname,
            kernel_release,
            kernel_version,
            machine,
            operating_system
        )
    elseif opts['n'] or opts['nodename'] then
        out = hostname .. '\n'
    elseif opts['r'] or opts['kernel-release'] then
        out = kernel_release .. '\n'
    elseif opts['v'] or opts['kernel-version'] then
        out = kernel_version .. '\n'
    elseif opts['m'] or opts['machine'] then
        out = machine .. '\n'
    elseif opts['p'] or opts['processor'] then
        out = processor .. '\n'
    elseif opts['i'] or opts['hardware-platform'] then
        out = hardware_platform .. '\n'
    elseif opts['o'] or opts['operating-system'] then
        out = operating_system .. '\n'
    elseif opts['version'] then
        out =  'version\n'
    elseif opts['help'] then
        out = 'help\n'
    else
        out = kernel_name .. '\n'
    end

    session:TermWrite(out)
    fmt.Println(opts, err)
end
