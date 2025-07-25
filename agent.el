(defun get-task-context ()
  "Get relevant context from current org position."
  (or
   ;; Try to get heading and content
   (when (org-at-heading-p)
     (org-get-entry))
   ;; Or get the current subtree
   (org-get-entry)
   ;; Or just get the current line
   (buffer-substring-no-properties 
    (line-beginning-position)
    (line-end-position))))

(defun get-ai-suggestion (context)
  "Get AI suggestion using gptel."
  (let ((gptel-buffer (get-buffer-create "*GPTel Response*")))
    (with-current-buffer gptel-buffer
      (erase-buffer)
      (gptel-send context)
      (buffer-string))))

(defun execute-generated-code (code)
  "Execute code safely in org-babel."
  (save-excursion
    (let ((temp-buffer (get-buffer-create "*Temp Org*")))
      (with-current-buffer temp-buffer
        (org-mode)
        (insert (format "#+BEGIN_SRC emacs-lisp\n%s\n#+END_SRC" code))
        (goto-char (point-min))
        (org-babel-execute-src-block)))))

(defun autonomous-task-workflow ()
  "Execute an autonomous workflow based on current org context."
  (interactive)
  (let* ((context (get-task-context))
         (ai-response (get-ai-suggestion context)))
    (when ai-response
      (execute-generated-code ai-response))))

(defvar *agent-mode-map* (make-sparse-keymap)
  "Keymap for agent mode.")

(define-derived-mode agent-mode fundamental-mode "Agent"
  "Major mode for executing agent tasks."
  (use-local-map *agent-mode-map*))

(defvar *planning-mode-map* (make-sparse-keymap)
  "Keymap for planning mode.")

(define-derived-mode planning-mode fundamental-mode "Planning"
  "Major mode for planning agent tasks."
  (use-local-map *planning-mode-map*))

(defun create-task-plan (task-description)
  "Generate a task plan using GPT."
  (interactive "sEnter task description: ")
  (let* ((planning-buffer (get-buffer-create "*Task Planning*"))
         (prompt (format "Create a detailed step-by-step plan for: %s
Include:
1. Required Emacs functions
2. Error handling considerations
3. Success criteria
Format as org-mode list." task-description)))
    (with-current-buffer planning-buffer
      (erase-buffer)
      (planning-mode)
      (gptel-send prompt)
      (pop-to-buffer planning-buffer))))

(defun execute-task-plan (plan)
  "Execute a task plan using the agent system."
  (interactive "sEnter task plan: ")
  (let* ((agent-buffer (get-buffer-create "*Agent Execution*"))
         (prompt (format "Execute this plan and generate Emacs Lisp code:
%s
Format the response as executable Emacs Lisp." plan)))
    (with-current-buffer agent-buffer
      (erase-buffer)
      (agent-mode)
      (let ((code (gptel-send prompt)))
        (insert "\n;; Generated Code:\n")
        (insert code)
        (insert "\n\n;; Execution Results:\n")
        (condition-case err
            (eval (read code))
          (error (insert (format "Error: %s" err))))
        (pop-to-buffer agent-buffer)))))

(defun agent-workflow (task-description)
  "Complete workflow from planning to execution."
  (interactive "sEnter task description: ")
  (let ((plan-buffer (get-buffer-create "*Task Planning*")))
    (with-current-buffer plan-buffer
      (erase-buffer)
      (planning-mode)
      (let* ((plan (create-task-plan task-description))
             (confirm (yes-or-no-p "Execute this plan? "))
             (execution (when confirm
                          (execute-task-plan plan))))))))

(agent-workflow
 "Read src/lib/posix.cpp, remove all hcl:: references and hcl includes, 
  display result in new buffer without saving to file.")

(define-key *agent-mode-map* (kbd "C-c C-e") 'execute-task-plan)
(define-key *planning-mode-map* (kbd "C-c C-p") 'create-task-plan)

(add-to-list 'auto-mode-alist '("\\.plan\\'" . planning-mode))
(add-to-list 'auto-mode-alist '("\\.agent\\'" . agent-mode))
