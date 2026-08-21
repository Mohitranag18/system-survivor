// Cross-platform helper to open a URL in the user's default browser.
function ok = open_url(url)
    ok = %f;
    // Basic validation
    if ~exists('url') then
        return
    end
    if typeof(url) == 'string' then
        if url == '' then
            return
        end
    elseif typeof(url) == 'tlist' then
        // defensive: convert to string if needed
        url = url(1)
    end

    // Remove embedded double-quotes to avoid shell breakage
    try
        url_safe = strsubst(url, char(34), '');
    catch
        url_safe = url;
    end

    // Try common platform commands in order. Suppress output and run in background where possible.
    // Linux: xdg-open, fallback gio
    cmd = 'xdg-open ' + url_safe + ' >/dev/null 2>&1 &';
    try
        host(cmd);
        ok = %t;
        return
    catch
    end

    cmd = 'gio open ' + url_safe + ' >/dev/null 2>&1 &';
    try
        host(cmd);
        ok = %t;
        return
    catch
    end

    // macOS
    cmd = 'open ' + url_safe + ' &';
    try
        host(cmd);
        ok = %t;
        return
    catch
    end

    // Windows (use cmd start)
    cmd = 'cmd /c start "" ' + url_safe;
    try
        host(cmd);
        ok = %t;
        return
    catch
    end
endfunction
