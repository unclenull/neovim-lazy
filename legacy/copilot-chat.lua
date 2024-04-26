local chat = require("CopilotChat")
local select = require("CopilotChat.select")
-- Use unnamed register for the selection

local prompts = {
  Concise = "Please rewrite the following text to make it more concise.",
  Commit = {
    prompt = "Write commit message for the change with commitizen convention",
    selection = select.gitdiff,
  },
  CommitStaged = {
    prompt = "Write commit message for the change with commitizen convention",
    selection = function(source)
      return select.gitdiff(source, true)
    end,
  },
}

opts = {
  -- separator = " ", -- Separator to use in chat
  prompts = prompts,
  auto_follow_cursor = false, -- Don't follow the cursor after getting response
  -- show_help = false, -- Show help in virtual text, set to true if that's 1st time using Copilot Chat
  -- window = {
  --   layout = 'vertical', -- 'vertical', 'horizontal', 'float'
  --   width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
  --   height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
  -- }
}

require("CopilotChat").setup(opts)

vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
  chat.ask(args.args, { selection = select.visual })
end, { nargs = "*", range = true })

-- Inline chat with Copilot
vim.api.nvim_create_user_command("CopilotChatInline", function(args)
  chat.ask(args.args, {
    selection = select.visual,
    window = {
      layout = "float",
      relative = "cursor",
      width = 1,
      height = 0.4,
      row = 1,
    },
  })
end, { nargs = "*", range = true })

-- Restore CopilotChatBuffer
vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
  chat.ask(args.args, { selection = select.buffer })
end, { nargs = "*", range = true })

-- Custom buffer for CopilotChat
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "copilot-*",
  callback = function()
    vim.opt_local.relativenumber = true
    vim.opt_local.number = true

    -- Get current filetype and set it to markdown if the current filetype is copilot-chat
    local ft = vim.bo.filetype
    if ft == "copilot-chat" then
      vim.bo.filetype = "markdown"
    end
  end,
})

keys = {
  -- Show help actions with telescope
  {
    "<leader>ah",
    function()
      local actions = require("CopilotChat.actions")
      require("CopilotChat.integrations.telescope").pick(actions.help_actions())
    end,
    desc = "CopilotChat - Help actions",
  },
  -- Show prompts actions with telescope
  {
    "<leader>ap",
    function()
      local actions = require("CopilotChat.actions")
      require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
    end,
    desc = "CopilotChat - Prompt actions",
  },
  {
    "<leader>ap",
    ":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
    mode = "x",
    desc = "CopilotChat - Prompt actions",
  },
  -- Code related commands
  { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
  { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
  { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
  { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
  { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
  -- Chat with Copilot in visual mode
  {
    "<leader>av",
    ":CopilotChatVisual",
    mode = "x",
    desc = "CopilotChat - Open in vertical split",
  },
  {
    "<leader>ax",
    ":CopilotChatInline<cr>",
    mode = "x",
    desc = "CopilotChat - Inline chat",
  },
  -- Custom input for CopilotChat
  {
    "<leader>ai",
    function()
      local input = vim.fn.input("Ask Copilot: ")
      if input ~= "" then
        vim.cmd("CopilotChat " .. input)
      end
    end,
    desc = "CopilotChat - Ask input",
  },
  -- Generate commit message based on the git diff
  {
    "<leader>am",
    "<cmd>CopilotChatCommit<cr>",
    desc = "CopilotChat - Generate commit message for all changes",
  },
  {
    "<leader>aM",
    "<cmd>CopilotChatCommitStaged<cr>",
    desc = "CopilotChat - Generate commit message for staged changes",
  },
  -- Quick chat with Copilot
  {
    "<leader>aq",
    function()
      local input = vim.fn.input("Quick Chat: ")
      if input ~= "" then
        vim.cmd("CopilotChatBuffer " .. input)
      end
    end,
    desc = "CopilotChat - Quick chat",
  },
  -- Debug
  { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
  -- Fix the issue with diagnostic
  { "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
  -- Clear buffer and chat history
  { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
  -- Toggle Copilot Chat Vsplit
  { "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
}
