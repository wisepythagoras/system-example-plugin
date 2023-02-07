fmt = import('fmt')
os = import('os')
strings = import('strings')

function prompt(session)
    e = '$'
    pwd = session:GetPWD()
    hostname = 'rpi'

    if session.User.Username == 'root' then
        e = '#'
    end

    if strings.HasPrefix(pwd, '/home/{}') then
        pwd = strings.ReplaceAll(pwd, '/home/{}', '~')
    elseif pwd == '' then
        pwd = '/'
    end

    _, h, err = session.VFS:FindFile('/etc/hostname')

    if err == nil then
        hostname = h.Contents
    end

    hostname = strings.Trim(hostname, '\n')

    return fmt.Sprintf('\27[32;1m%s@%s\27[0m:\27[34;1m%s\27[0m%s ', session.User.Username, hostname, pwd, e)
end

function login_msg(session)
    _, f, err = session.VFS:FindFile('/etc/motd')

    if err ~= nil then
        return ''
    end

    -- Emulate motd scripts: /etc/update-motd.d
    out = fmt.Sprintf('Welcome to Raspberry OS\n%s', f.Contents)

    return out
end

function install(config)
    fmt.Println('\27[31;1;4mEmulating Raspberry OS\27[0m')
    config:RegisterPrompt(prompt)
    config:RegisterLoginMessage(login_msg)
end
