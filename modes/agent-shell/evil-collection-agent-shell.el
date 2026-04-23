;;; evil-collection-agent-shell.el --- Bindings for agent-shell -*- lexical-binding: t -*-

;; Copyright (C) 2026 Joseph LaFreniere

;; Author: Joseph LaFreniere <git@lafreniere.xyz>
;; Maintainer: Joseph LaFreniere <git@lafreniere.xyz>
;; URL: https://github.com/emacs-evil/evil-collection
;; Version: 0.0.1
;; Package-Requires: ((emacs "29.1"))
;; Keywords: evil, agent-shell, tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;; Bindings for agent-shell.

;;; Code:
(require 'evil-collection)
(require 'agent-shell nil t)

(defconst evil-collection-agent-shell-maps '(agent-shell-mode-map
                                             agent-shell-viewport-edit-mode-map
                                             agent-shell-viewport-view-mode-map
                                             agent-shell-diff-mode-map))

(defvar agent-shell-mode-map)
(defvar agent-shell-viewport-edit-mode-map)
(defvar agent-shell-viewport-view-mode-map)
(defvar agent-shell-diff-mode-map)

;;;###autoload
(defun evil-collection-agent-shell-setup ()
  "Set up `evil' bindings for `agent-shell'."
  ;; `agent-shell-mode-map' binds \"n\" and \"p\" at the map level, which causes
  ;; them to intercept keystrokes even in insert state.  Remove those bindings
  ;; entirely.
  (define-key agent-shell-mode-map "n" nil)
  (define-key agent-shell-mode-map "p" nil)

  (evil-collection-define-key 'normal 'agent-shell-mode-map
    (kbd "TAB") 'agent-shell-next-item
    "<backtab>" 'agent-shell-previous-item
    "C-<tab>" 'agent-shell-cycle-session-mode)

  (when evil-collection-want-g-bindings
    (evil-collection-define-key 'normal 'agent-shell-mode-map
      "gs" 'agent-shell-cycle-session-mode
      "gx" 'agent-shell-interrupt
      "gm" 'agent-shell-set-session-mode
      "gv" 'agent-shell-set-session-model
      "go" 'agent-shell-other-buffer
      "gp" 'agent-shell-yank-dwim
      "gr" 'agent-shell-reload
      "gR" 'agent-shell-restart
      "gF" 'agent-shell-fork
      "gy" 'agent-shell-copy-session-id
      "gc" 'agent-shell-prompt-compose
      "gq" 'agent-shell-queue-request
      "gt" 'agent-shell-open-transcript))

  (evil-collection-define-key 'normal 'agent-shell-viewport-edit-mode-map
    [remap evil-save-and-close] 'agent-shell-viewport-compose-send
    [remap evil-save-modified-and-close] 'agent-shell-viewport-compose-send
    [remap evil-ret] 'agent-shell-viewport-compose-send
    [remap evil-write] 'agent-shell-viewport-compose-send
    [remap evil-quit] 'agent-shell-viewport-compose-cancel
    "M-k" 'agent-shell-viewport-previous-history
    "M-j" 'agent-shell-viewport-next-history
    (kbd "C-o") 'agent-shell-viewport-compose-peek-last)

  (when evil-collection-want-g-bindings
    (evil-collection-define-key 'normal 'agent-shell-viewport-edit-mode-map
      "g?" 'agent-shell-viewport-compose-help-menu
      "gs" 'agent-shell-cycle-session-mode
      "gm" 'agent-shell-viewport-set-session-mode
      "gv" 'agent-shell-viewport-set-session-model
      "go" 'agent-shell-other-buffer
      "gp" 'agent-shell-yank-dwim
      "g/" 'agent-shell-viewport-search-history
      "gy" 'agent-shell-viewport-copy-session-id
      "gt" 'agent-shell-viewport-open-transcript))

  (evil-collection-define-key 'normal 'agent-shell-viewport-view-mode-map
    [remap evil-save-and-close] 'agent-shell-viewport-interrupt
    [remap evil-save-modified-and-close] 'agent-shell-viewport-interrupt
    [remap evil-ret] 'agent-shell-viewport-interrupt
    [remap evil-write] 'agent-shell-viewport-interrupt
    [remap evil-quit] 'bury-buffer
    (kbd "TAB") 'agent-shell-viewport-next-item
    (kbd "<backtab>") 'agent-shell-viewport-previous-item
    "gj" 'agent-shell-viewport-next-item
    "gk" 'agent-shell-viewport-previous-item
    (kbd "C-j") 'agent-shell-viewport-next-page
    (kbd "C-k") 'agent-shell-viewport-previous-page
    "q" 'bury-buffer)

  (when evil-collection-want-g-bindings
    (evil-collection-define-key 'normal 'agent-shell-viewport-view-mode-map
      "g1" 'agent-shell-viewport-reply-1
      "g2" 'agent-shell-viewport-reply-2
      "g3" 'agent-shell-viewport-reply-3
      "g4" 'agent-shell-viewport-reply-4
      "g5" 'agent-shell-viewport-reply-5
      "g6" 'agent-shell-viewport-reply-6
      "g7" 'agent-shell-viewport-reply-7
      "g8" 'agent-shell-viewport-reply-8
      "g9" 'agent-shell-viewport-reply-9
      "gs" 'agent-shell-viewport-cycle-session-mode
      "gv" 'agent-shell-viewport-set-session-model
      "go" 'agent-shell-other-buffer
      "gm" 'agent-shell-viewport-set-session-mode
      "g?" 'agent-shell-viewport-help-menu
      ;; Maybe move elsewhere.
      "gr" 'agent-shell-viewport-reply
      "gy" 'agent-shell-viewport-reply-yes
      "gM" 'agent-shell-viewport-reply-more
      "ga" 'agent-shell-viewport-reply-again
      "gc" 'agent-shell-viewport-reply-continue
      "ge" 'agent-shell-viewport-edit
      "gF" 'agent-shell-viewport-fork
      "gY" 'agent-shell-viewport-copy-session-id
      "gt" 'agent-shell-viewport-open-transcript
      "gz" 'agent-shell-viewport-refresh))

  (evil-collection-define-key 'normal 'agent-shell-diff-mode-map
    "y" #'agent-shell-diff-accept-all
    "gx" #'agent-shell-diff-reject-all
    "go" #'agent-shell-diff-open-file
    "q" #'kill-current-buffer))

(provide 'evil-collection-agent-shell)
;;; evil-collection-agent-shell.el ends here
