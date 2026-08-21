-- basedpyright: type checking, completion and navigation.
--
-- Lives in `after/lsp/` for the precedence reason documented in ruff.lua.
--
-- Deliberately absent: `on_attach`, `filetypes` and `root_markers`. The force
-- merge would *replace* lspconfig's `on_attach`, taking the
-- `:LspPyrightOrganizeImports` and `:LspPyrightSetPythonPath` commands with it,
-- and its filetypes/root_markers are already what we want.
local venv = require('core.venv')

local config = venv.server {
  exe = 'basedpyright-langserver',
  args = { '--stdio' },
  markers = {
    'pyrightconfig.json',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
  install = 'uv tool install basedpyright',
}

---@type lspconfig.settings.basedpyright
config.settings = {
  basedpyright = {
    analysis = {
      -- basedpyright's own default is 'recommended', which also turns on
      -- reportAny, reportExplicitAny, reportUnannotatedClassAttribute,
      -- reportUnusedParameter and failOnWarnings — very loud on code that
      -- isn't fully annotated. 'standard' matches upstream pyright's default.
      -- A project's pyproject.toml or pyrightconfig.json still overrides this.
      typeCheckingMode = 'standard',
    },
  },
}

-- basedpyright already defaults pythonPath to ./.venv, so this mainly covers
-- $VIRTUAL_ENV and non-standard venv locations.
config.before_init = function(_, client_config)
  local python = venv.resolve(client_config.root_dir, 'python')
  if python then
    client_config.settings = vim.tbl_deep_extend('force', client_config.settings or {}, {
      python = { pythonPath = python },
    })
  end
end

---@type vim.lsp.Config
return config
