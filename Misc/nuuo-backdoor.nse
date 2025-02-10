local shortport = require "shortport"
local http = require "http"
local stdnse = require "stdnse"
local string = require "string"

description = [[
Nmap script to detect a backdoor root access in NUUO NVR devices.
NUUO NVR/DVR/NDVR Remote Root Exploit
Advisory ID: ZSL-2016-5348
Advisory URL: http://www.zeroscience.mk/en/vulnerabilities/ZSL-2016-5348.php
]]

---
-- @usage
-- nmap --script nuuo-backdoor <target> -p80
-- @output
-- PORT    STATE  SERVICE
-- 80/tcp  open   http
-- | nuuo-backdoor:
-- |
-- | Backdoor detected! Take teh root!
-- | Reference:
-- |   http://www.zeroscience.mk/en/vulnerabilities/ZSL-2016-5348.php
-- |_

author = "LiquidWorm"
license = "Same as Nmap--See http://nmap.org/book/man-legal.html"
categories = {"default", "safe"}

portrule = shortport.http

action = function(host, port)

    local options = {header={}}
    options['header']['User-Agent'] = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36"
    local uri = "/__debugging_center_utils___.php"
    local response = http.get(host, port, uri, options)
    local title = string.match(response.body, "<[Tt][Ii][Tt][Ll][Ee][^>]*>Debugging ([^<]*)</[Tt][Ii][Tt][Ll][Ee]>")
    if ( response.status == 200 and title == "Center" ) then
        local reft = "Reference:\n"
        local refu = "  http://www.zeroscience.mk/en/vulnerabilities/ZSL-2016-5348.php\n\n"
        return " \n\nBackdoor detected! Take teh root! \n"..reft..refu
    end
end