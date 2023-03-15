local M = {}

local function regexEscape(str)
  return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

function M.find_spec(file, work_dir, config)
  local config = config or { excluded_paths = {} }
  local file_name = file:match("^.+/(.+)$")
  local file_path = file:match("^(.*[\\/])")
  local spec_file_name = file_name:gsub("%.", "_spec.")
  local relative_file_path = file_path:gsub(regexEscape(work_dir), "")

  for _, path in ipairs(config.excluded_paths) do
    relative_file_path = relative_file_path:gsub(("^/" .. path .. "/"), "/")
  end

  if file_name:match("_spec") then
    local possiblePaths = {}

    for _, path in ipairs(config.excluded_paths) do
      local path_without_spec = relative_file_path:gsub("^/spec/", "/")
      local file_name_without_spec = file_name:gsub("_spec", "")
      table.insert(
        possiblePaths,
        (work_dir .. "/" .. path .. path_without_spec .. file_name_without_spec)
      )
    end

    return possiblePaths
  else
    return {(work_dir .. "/spec" .. relative_file_path .. spec_file_name)}
  end
end

function M.jump_to_test()
  local bufferName = vim.api.nvim_buf_get_name(0)
  local workDir = vim.fn.getcwd()
  local config = { excluded_paths = {"lib", "apps"} }

  vim.fn.filereadable("")
  local results = M.find_spec(bufferName, workDir, config)
  local existing = {}
  for _, file in ipairs(results) do
    if vim.fn.filereadable(file) == 1 then
      table.insert(existing, file)
    end
  end

  if #existing > 0 then
    vim.cmd("e " .. existing[1])
    print(existing[1])
  else
    if #results == 1 then
      vim.cmd("e " .. results[1])
      return
    end

    vim.ui.input({
      prompt = ("Possible options: \n1: " .. table.concat(results, "\n2: ") .. "\nEnter number: ")},
      function(input)
        local selection = tonumber(input)
        if selection then
          vim.cmd("e " .. results[tonumber(input)])
        else
          print("Invalid selection")
        end
      end)
  end
end

return M;
