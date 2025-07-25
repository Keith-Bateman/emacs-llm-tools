(use-package copilot-chat)

(use-package copilot
  :ensure t
  :hook (prog-mode . copilot-mode)
  :config
  (setq copilot-idle-delay 0.5)
  (setq copilot-max-suggestions 3))

(require 'gptel)

(setq gptel-model 'claude-3.5-sonnet
      gptel-backend (gptel-make-gh-copilot "Copilot"))

(use-package org-ai
  :ensure t
  :commands (org-ai-mode)
  :hook (org-mode . org-ai-mode))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (emacs-lisp . t)
   (shell . t)))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/org-roam")
  :config
  (org-roam-db-autosync-mode))

(use-package websocket :ensure t)
(use-package request :ensure t)
(use-package log4e :ensure t)
(use-package json-mode :ensure t)

(add-to-list 'load-path "~/emacs-llm-tools/agent.el")

(setq copilot-chat-curl-proxy-user-pass "username:password") ; You can set this up if you want, I believe it's not necessary

(add-to-list 'load-path "~/mcp.el")
(require 'mcp-hub)

(setq mcp-hub-servers
      '(("git" . (:command "uvx" :args ("mcp-server-git" "--repository" "~/mcp-servers")))))
