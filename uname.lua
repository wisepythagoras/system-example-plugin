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
    _, raw, err = args:ParseOpts(flags)

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
        out =  'version\n'
    elseif flags:Get('help') then
        out = 'help\n'
    else
        out = kernel_name .. '\n'
    end

    session:TermWrite(out)
end
