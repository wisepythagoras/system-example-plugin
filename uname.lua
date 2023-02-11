fmt = import('fmt')
strings = import('strings')
opts = import('opts')

-- If Honeyshell is running on a system you're trying to emulate, then you can
-- get these values in realtime from your system, instead of hardcoding them.
local kernel_name = 'Linux'
local kernel_release = '5.15.84-v7+'
local kernel_version = '#1613 SMP Thu Jan 5 11:59:48 GMT 2023'
local machine = 'armv7l'
local processor = 'unknown'
local hardware_platform = 'unknown'
local operating_system = 'GNU/Linux'

function get_flags()
    flags = opts.CreateOptsConfig()
    flags:AddBoth('-a', '--all', false)
    flags:AddBoth('-s', '--kernel-name', false)
    flags:AddBoth('-n', '--nodename', false)
    flags:AddBoth('-r', '--kernel-release', false)
    flags:AddBoth('-v', '--kernel-version', false)
    flags:AddBoth('-m', '--machine', false)
    flags:AddBoth('-p', '--processor', false)
    flags:AddBoth('-i', '--hardware-platform', false)
    flags:AddBoth('-o', '--operating-system', false)
    flags:AddOne('--help', false)
    flags:AddOne('--version', false)

    return flags
end

function uname_command(args, session)
    flags = get_flags()
    _, raw, err = args:ParseOpts(flags, false)

    if err ~= nil then
        session:TermWrite(err:String())
    end

    out = ''
    hostname = 'rpi'

    _, h, err = session.VFS:FindFile('/etc/hostname')

    if err == nil then
        hostname = strings.Trim(h.Contents, '\n')
    end

    if flags:Get('a') or flags:Get('all') then
        out = fmt.Sprintf(
            '%s %s %s %s %s %s\n',
            kernel_name,
            hostname,
            kernel_release,
            kernel_version,
            machine,
            operating_system
        )
    elseif flags:Get('n') or flags:Get('nodename') then
        out = hostname .. '\n'
    elseif flags:Get('r') or flags:Get('kernel-release') then
        out = kernel_release .. '\n'
    elseif flags:Get('v') or flags:Get('kernel-version') then
        out = kernel_version .. '\n'
    elseif flags:Get('m') or flags:Get('machine') then
        out = machine .. '\n'
    elseif flags:Get('p') or flags:Get('processor') then
        out = processor .. '\n'
    elseif flags:Get('i') or flags:Get('hardware-platform') then
        out = hardware_platform .. '\n'
    elseif flags:Get('o') or flags:Get('operating-system') then
        out = operating_system .. '\n'
    elseif flags:Get('version') then
        -- This is just for emulation/simulation purposes and this software does not claim any rights
        -- to the underliying coreutils software.
        out =  'uname (GNU coreutils) 8.32\n'
        out = out .. 'Copyright (C) 2020 Free Software Foundation, Inc.\n'
        out = out .. 'License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.\n'
        out = out .. 'This is free software: you are free to change and redistribute it.\n'
        out = out .. 'There is NO WARRANTY, to the extent permitted by law.\n\n'
        out = out .. 'Written by Devid McKenzie.\n' -- This name was purposely altered.
    elseif flags:Get('help') then
        -- This is just for emulation/simulation purposes and this software does not claim any rights
        -- to the underliying coreutils software.
        out = 'Usage: uname [OPTION]...\n'
        out = out .. 'Print certain system information.  With no OPTION, same as -s.\n\n'
        out = out .. '  -a, --all                print all information, in the following order,\n'
        out = out .. '                             except omit -p and -i if unknown:\n'
        out = out .. '  -s, --kernel-name        print the kernel name\n'
        out = out .. '  -n, --nodename           print the network node hostname\n'
        out = out .. '  -r, --kernel-release     print the kernel release\n'
        out = out .. '  -v, --kernel-version     print the kernel version\n'
        out = out .. '  -m, --machine            print the machine hardware name\n'
        out = out .. '  -p, --processor          print the processor type (non-portable)\n'
        out = out .. '  -i, --hardware-platform  print the hardware platform (non-portable)\n'
        out = out .. '  -o, --operating-system   print the operating system\n'
        out = out .. '      --help     display this help and exit\n'
        out = out .. '      --version  output version information and exit\n\n'
        out = out .. 'GNU coreutils online help: <https://www.gnu.org/software/coreutils/>\n'
        out = out .. 'Full documentation <https://www.gnu.org/software/coreutils/uname>\n'
        out = out .. 'or available locally via: info \'(coreutils) uname invocation\'\n'
    else
        if len(raw) > 0 then
            arg = raw[1]
            out = 'uname: '

            if strings.HasPrefix(arg, '-') then
                if strings.HasPrefix(arg, '--') then
                    out = fmt.Sprintf(out .. 'unrecognized option \'%s\'\n', arg)
                else
                    arg = strings.ReplaceAll(arg, '-', '')
                    out = fmt.Sprintf(out .. 'invalid option -- \'%s\'\n', arg)
                end
            else
                out = fmt.Sprintf(out .. 'extra operand -- \'%s\'\n', arg)
            end

            out = out .. 'Try \'uname --help\' for more information.\n'
            session:TermWrite(out)

            return
        end
        out = kernel_name .. '\n'
    end

    session:TermWrite(out)
end
