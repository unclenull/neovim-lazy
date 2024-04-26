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

mappings = {
  submit_prompt = {
    normal = "<CR>",
    insert = "<C-CR>",
  },
}

opts = {
  -- separator = " ", -- Separator to use in chat
  prompts = prompts,
  mappings = mappings,
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

-- vim.keymap.set({
--   '<leader>ah',
--   function()
--     local actions = require("CopilotChat.actions")
--     echom(actions.help_actions())
--   end,
--   silent = true
-- })
-- 
--   -- Show prompts actions with telescope
-- vim.keymap.set({
--     "<leader>ap",
--     function()
--       local actions = require("CopilotChat.actions")
--       print(actions.prompt_actions())
--     end,
--   silent = true
-- })
-- vim.keymap.set({
--     "<leader>ap",
--     ":lua print(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
--   silent = true
-- })
  -- Code related commands
vim.keymap.set("n", "<leader>ae", "<cmd>CopilotChatExplain<cr>")
vim.keymap.set("n", "<leader>at", "<cmd>CopilotChatTests<cr>")
vim.keymap.set("n", "<leader>ar", "<cmd>CopilotChatReview<cr>")
vim.keymap.set("n", "<leader>aR", "<cmd>CopilotChatRefactor<cr>")
vim.keymap.set("n", "<leader>an", "<cmd>CopilotChatBetterNamings<cr>")
  -- Chat with Copilot in visual mode
vim.keymap.set("n",
    "<leader>av",
    ":CopilotChatVisual"
)
vim.keymap.set("n",
    "<leader>ax",
    ":CopilotChatInline<cr>"
)
  -- Custom input for CopilotChat
-- vim.keymap.set({
--     "<leader>ai",
--     function()
--       local input = vim.fn.input("Ask Copilot: ")
--       if input ~= "" then
--         vim.cmd("CopilotChat " .. input)
--       end
--     end,
--   silent = true
-- })
  -- Generate commit message based on the git diff
vim.keymap.set("n",
    "<leader>am",
    "<cmd>CopilotChatCommit<cr>"
)
vim.keymap.set("n",
    "<leader>aM",
    "<cmd>CopilotChatCommitStaged<cr>"
)
  -- Quick chat with Copilot
-- vim.keymap.set({
--     "<leader>aq",
--     function()
--       local input = vim.fn.input("Quick Chat: ")
--       if input ~= "" then
--         vim.cmd("CopilotChatBuffer " .. input)
--       end
--     end,
--   silent = true
-- })
  -- Debug
vim.keymap.set("n", "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>")
-- Fix the issue with diagnostic
vim.keymap.set("n", "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>")
-- Clear buffer and chat history
vim.keymap.set("n", "<leader>al", "<cmd>CopilotChatReset<cr>")
-- Toggle Copilot Chat Vsplit
vim.keymap.set("n", "<leader>av", "<cmd>CopilotChatToggle<cr>")
