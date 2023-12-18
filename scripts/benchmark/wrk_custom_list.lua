local counter = 1
local lines = {}
local base_path = "/planet/20231208_091355/tiles/"
local file_path = "/data/ofm/benchmark/path_list_100k.txt"

for line in io.lines(file_path) do
    table.insert(lines, base_path .. line)
end

local function getNextUrl()
    -- Get the next URL from the list
    local url_path = lines[counter]
    counter = counter + 1

    -- If we've gone past the end of the list, wrap around to the start
    if counter > #lines then
        counter = 1
    end

    return url_path
end

request = function()
    -- Return the request object with the current URL path
    path = getNextUrl()
    local headers = {}
    headers["Host"] = "ofm"
    return wrk.format('GET', path, headers, nil)
end

response = function(status)
    if status ~= 200 then
        print("Non-200 response")
        print("Status: ", status)
        -- this only works in single threaded mode (-t1)
        print("Request path: ", path)
    end
end

