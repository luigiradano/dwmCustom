return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")

    -- Configure linting for C files
    lint.linters_by_ft = {
      c = { "clangtidy" }, -- You can replace "clangtidy" with "clangcheck" if preferred
      h = { "clangtidy" }, -- You can replace "clangtidy" with "clangcheck" if preferred
    }

    -- Set up autocmd to run linting on file save
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
