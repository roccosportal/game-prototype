function string.starts(s,start)
   return string.sub(s,1,string.len(start))==start
end

function string.ends(s, send)
  return #s >= #send and s:find(send, #s-#send+1, true) and true or false
end
