#!/usr/bin/lua

local uci = require("uci").cursor()

local password = ''
salt_path = 'salt.txt'
output = 'location.txt'
dry = true

function exec_silent(command)
	local p = assert(io.popen(command, 'r'))
	local result = p:read('*all')
	p:close()
	return result
end

function sha512(input)
	-- it's important to escape single quotes!
	local result = exec_silent("echo -n '"..input.."' | sha512sum")
	-- remove stdin from output
	result = result:gsub('-', '')
	-- remove whitespace from output
	result = result:gsub(' ', '')
	result = result:gsub('\n', '')
	return result
end

function readSalt()
	return exec_silent('cat '..salt_path)
end

function genSalt()
	-- I think /dev/random should be more secure
	return exec_silent('dd if=/dev/random bs=1024 count=1 2>/dev/null | md5sum -b | head -c 32 > '..salt_path)
end

function checkSalt()
	-- This function check's wheter the salt already exists
	return io.open(salt_path, 'r') ~= nil
end

if not checkSalt() then
	genSalt()
	io.write('Content-type: text/html\n\n')
	io.write('wrote salt.')
	os.exit()
end

input = io.read()
input = input:gmatch('[^,]+')

lat = input()
lon = input()
hash = input()
salt = readSalt()

test = lat..lon..password..salt

io.write('Content-type: text/html\n\n')

io.write('lat='..lat..' lon='..lon..' hash='..hash..'\n')

if sha512(test) == hash then
	io.write('access=OK\n')
	genSalt()
	exec_silent("echo 'lat="..lat.." lon="..lon.."' > "..output)
	
	if not dry then
		local sname = uci:get_first("gluon-node-info", "location")
		uci:set("gluon-node-info", sname, "latitude", lat)
		uci:set("gluon-node-info", sname, "longitude", lon)
		uci:save("gluon-node-info")
		uci:commit("gluon-node-info")
	end
 
	io.write('status=DONE\n')
else
	io.write('access=DENIED\n')
end