local M = {}

function M.root_multi(dirname, markers)
  -- Find all potential marker files by searching upwards.
  local all_matches = vim.fs.find(markers, {
    path = dirname,
    upward = true,
    multiple = true,
  })

  if #all_matches == 0 then
    return nil -- No markers found.
  end

  -- Count how many markers are present in each directory.
  local directory_counts = {}
  for _, path in ipairs(all_matches) do
    local dir = vim.fs.dirname(path)
    directory_counts[dir] = (directory_counts[dir] or 0) + 1
  end

  -- Find the directory with the maximum number of matches.
  local best_dir = nil
  local max_count = 0
  for dir, count in pairs(directory_counts) do
    if count > max_count then
      max_count = count
      best_dir = dir
      -- Optional: For ties, you could add logic to prefer the
      -- closest parent directory, but `vim.fs.find()`
      -- naturally prioritizes closer matches in its initial list.
    end
  end
  return best_dir
end

return M
