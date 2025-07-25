# emacs-llm-tools
Personal tools and docs for using LLMs and Agentic AI in Emacs

Some external tools I recommend:
- gptel
- copilot-mode

## agent.el
This is an agentic configuration for Emacs. It includes a few functions in order to create and execute plans. create-task-plan and execute-task-plan will go through your typical workflow of asking an AI to plan out work which you can then send to another AI to perform. 

Also of note is agent-workflow, which performs both plan creation and execution with a simple yes or no confirm in between. Note that the plan gets put into a separate buffer either way, so you can analyze the results afterward if you wish.

I set up some hotkeys on C-c C-p and C-c C-e to perform task creation and execution when in planning or execution mode, this maps to the more typical workflow of planning and executing where you switch modes in order to engage with a planner or executor.

## dot-emacs.el
This is just a configuration, it shows all the packages I use in my LLM-empowered emacs (usually you put these in "~/.emacs"). Try package-list-packages to find anything you don't have and install it. You might need melpa, depending on the package. Also see "session.org" for the copilot mode session I created the agent tool in, just in case a package is required that I didn't include in the dot-emacs.el file.

## copilot-mode
External tool. It gives a nice org mode interface for interacting with GitHub Copilot in Emacs. I usually start with "copilot-chat-display". That brings up a window for talking with copilot. Then you should do "copilot-chat-set-model" to select a model and you can chat. A simple discussion I usually have is to send it a code block and discuss it. You can see an example interaction in "session.org", but it usually looks something like:

```
#+BEGIN_SRC c++
int main() {
  printf("Hello World\n");
}
#+END_SRC

Can you tell me what this source code does?
```

When you've typed something like that, you do "C-c C-c" to send to the chat and get a response. You can also add files and buffers to the context with "copilot-chat-add-file", "copilot-chat-add-current-buffer", "copilot-chat-add-buffers", etc.

## gptel
External tool. It gives a more straightforward interface for interacting with AI that can be useful in building higher-level tools (agent.el uses it) or connecting to backends outside of Copilot. I don't use it often interactively, but a useful function is "gptel-send". It sends a context to the model and get a response in the current buffer.

## mcp.el
This is an external tool. It's supposed to let you use mcp servers in Emacs, I don't use it often but it's available

https://github.com/lizqwerscott/mcp.el

https://github.com/modelcontextprotocol/servers
