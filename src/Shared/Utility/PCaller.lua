--!strict
local PCaller = {}

PCaller.Execute = function(func, maxAttempts, message)
    local attempts = 0
    repeat 
        local success, errorMessage = pcall(func)
        
        attempts += 1
        local retrying = attempts < 4
        local preamble = retrying and "Retrying..." or "Retries exhausted."
        warn(`{preamble} {message}: {errorMessage}`)
        if not retrying then
            break
        end

        task.wait(1)
    until success
end

return PCaller