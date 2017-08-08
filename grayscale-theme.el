;; grayscale-theme.el -- simple grayscale theme for emacs

;; Author: Kaleb Elwert <belak@coded.io>
;; Maintainer: Kaleb Elwert <belak@coded.io>
;; Version: 0.1
;; Homepage: https://github.com/belak/emacs-grayscale-theme

;;; Commentary:

;; This theme is a mostly grayscale theme which uses the zenburn
;; colors as highlights.

;;; Code:

(defun grayscale-transform-spec (spec colors)
  "Transform a theme `SPEC' into a face spec using `COLORS'."
  (let ((output))
    (while spec
      (let* ((key       (car  spec))
             (value     (cadr spec))
             (color-key (if (symbolp value) (intern (concat ":" (symbol-name value))) nil))
             (color     (plist-get colors color-key)))

        ;; Append the transformed element
        (cond
         ((and (memq key '(:box :underline)) (listp value))
          (setq output (append output (list key (grayscale-transform-spec value colors)))))
         (color
          (setq output (append output (list key color))))
         (t
          (setq output (append output (list key value))))))

      ;; Go to the next element in the list
      (setq spec (cddr spec)))

    ;; Return the transformed spec
    output))

(defun grayscale-transform-face (spec colors)
  "Transform a face `SPEC' into an Emacs theme face definition using `COLORS'."
  (let* ((face             (car spec))
         (definition       (cdr spec)))

    (list face `((t ,(grayscale-transform-spec definition colors))))))

(defun grayscale-set-faces (theme-name colors faces)
  "Define the important part of `THEME-NAME' using `COLORS' to map the `FACES' to actual colors."
  (apply 'custom-theme-set-faces theme-name
         (mapcar #'(lambda (face)
                     (grayscale-transform-face face colors))
                 faces)))

(defvar grayscale-theme-colors
  ;; The bg and fg colors were originally built as a mix between the
  ;; base16-grayscale and the duotone atom theme colors but have
  ;; been tweaked a bit since then. I've used the duotone idea of
  ;; one main foreground color with muted and brightened
  ;; variants. The highlight colors have been adapted from zenburn.
  '(:bg        "#2e2e2e"
    :bg+1      "#383838"
    :bg+2      "#424242"
    :bg+3      "#474747"
    :fg-1      "#868686"
    :fg        "#b6b6b6"
    :fg+1      "#e6e6e6"
    :red-1     "#8c5353"
    :red       "#bc8383"
    :red+1     "#dca3a3"
    :orange    "#dfaf8f"
    :yellow    "#d0bf8f"
    :yellow+1  "#f0dfaf"
    :green     "#7f9f7f"
    :green+1   "#8fb28f"
    :blue      "#6ca0a3"
    :blue+1    "#94bff3"
    :cyan      "#8cd0d3"
    :cyan+1    "#93e0e3"
    :magenta   "#dc8cc3"
    :magenta+1 "#ec93d3"))

(deftheme grayscale)
(grayscale-set-faces
 'grayscale
 grayscale-theme-colors

 '(
;;; Built-in

;;;; basic colors
   (border                                       :background bg+2)
   (cursor                                       :background fg-1)
   (default                                      :foreground fg :background bg)
   (fringe                                       :background bg+2)
   (gui-element                                  :background bg+1)
   (header-line                                  :background nil :inherit mode-line)
   (highlight                                    :background bg+1)
   (link                                         :foreground blue :underline t)
   (link-visited                                 :foreground magenta :underline t)
   (minibuffer-prompt                            :foreground blue)
   (region                                       :background bg+2)
   (secondary-selection                          :background bg+2)
   (trailing-whitespace                          :foreground yellow :background blue+1)
   (widget-button                                :underline t)
   (widget-field                                 :background fg-1 :box (:line-width 1 :color fg+1))

   (error                                        :foreground red    :weight bold)
   (warning                                      :foreground orange :weight bold)
   (success                                      :foreground green  :weight bold)

;;;; font-lock
   (font-lock-builtin-face                       :foreground fg+1)
   (font-lock-comment-delimiter-face             :foreground fg-1)
   (font-lock-comment-face                       :foreground fg-1)
   (font-lock-constant-face                      :foreground fg-1)
   (font-lock-doc-face                           :foreground fg-1)
   (font-lock-doc-string-face                    :foreground fg-1)
   (font-lock-function-name-face                 :foreground fg+1)
   (font-lock-keyword-face                       :foreground fg+1)
   (font-lock-negation-char-face                 :foreground fg-1)
   (font-lock-preprocessor-face                  :foreground fg-1)
   (font-lock-regexp-grouping-backslash          :foreground fg-1)
   (font-lock-regexp-grouping-construct          :foreground fg)
   (font-lock-string-face                        :foreground fg-1)
   (font-lock-type-face                          :foreground fg)
   (font-lock-variable-name-face                 :foreground fg+1)
   (font-lock-warning-face                       :foreground yellow)

;;;; isearch
   (match                                        :foreground fg+1 :inverse-video t)
   (isearch                                      :foreground fg+1 :inverse-video t :weight bold)
   (lazy-highlight                               :foreground fg-1 :inverse-video t)
   (isearch-fail                                 :foreground red-1 :background fg :inverse-video t)

;;;; line-numbers
   (line-number                                  :foreground fg-1 :background bg+1)
   (line-number-current-line                     :inverse-video t :inherit line-number)

;;;; mode-line
   (mode-line                                    :foreground fg-1 :background bg+2 :box (:line-width -1 :style released-button))
   (mode-line-buffer-id                          :foreground fg+1 :background nil)
   (mode-line-emphasis                           :foreground fg+1 :slant italic)
   (mode-line-highlight                          :foreground magenta :box nil :weight bold)
   (mode-line-inactive                           :foreground fg-1 :background bg+1 :box (:line-width -1 :style released-button))

;;; Third-party

;;;; anzu-mode
   (anzu-mode-line                               :foreground yellow)

;;;; company-mode
   (company-tooltip                              :background bg+2 :inherit default)
   (company-scrollbar-bg                         :background fg+1)
   (company-scrollbar-fg                         :background fg-1)
   (company-tooltip-annotation                   :foreground red)
   (company-tooltip-common                       :inherit font-lock-constant-face)
   (company-tooltip-selection                    :background bg+3 :inherit font-lock-function-name-face)
   (company-preview-common                       :inherit secondary-selection)

;;;; diff-hl-mode
   (diff-hl-change                               :background blue  :foreground blue+1)
   (diff-hl-delete                               :background red   :foreground red+1)
   (diff-hl-insert                               :background green :foreground green+1)

;;;; diff-mode
   (diff-added                                   :foreground green)
   (diff-changed                                 :foreground magenta)
   (diff-removed                                 :foreground red)
   (diff-header                                  :background bg)
   (diff-file-header                             :background bg+1)
   (diff-hunk-header                             :foreground magenta :background bg)

;;;; flycheck-mode
   (flycheck-error                               :underline (:style wave :color red))
   (flycheck-info                                :underline (:style wave :color yellow))
   (flycheck-warning                             :underline (:style wave :color orange))

;;;; flyspell-mode
   (flyspell-duplicate                           :underline (:style wave :color orange))
   (flyspell-incorrect                           :underline (:style wave :color red))

;;;; ido-mode
   (ido-subdir                                   :foreground fg-1)
   (ido-first-match                              :foreground orange :weight bold)
   (ido-only-match                               :foreground green :weight bold)
   (ido-indicator                                :foreground red :background bg+1)
   (ido-virtual                                  :foreground fg-1)

;;;; org-mode
   ;; TODO: Most of these shouldn't use accent colors.
   (org-agenda-structure                         :foreground magenta)
   (org-agenda-date                              :foreground blue :underline nil)
   (org-agenda-done                              :foreground green)
   (org-agenda-dimmed-todo-face                  :foreground fg-1)
   (org-block                                    :foreground fg)
   (org-code                                     :foreground fg)
   (org-column                                   :background bg+1)
   (org-column-title                             :weight bold :underline t :inherit org-column)
   (org-date                                     :foreground magenta :underline t)
   (org-document-info                            :foreground blue+1)
   (org-document-info-keyword                    :foreground green)
   (org-document-title                           :foreground orange :weight bold :height 1.44)
   (org-done                                     :foreground green)
   (org-ellipsis                                 :foreground fg-1)
   (org-footnote                                 :foreground blue+1)
   (org-formula                                  :foreground red)
   (org-hide                                     :foreground fg-1)
   (org-link                                     :foreground blue)
   (org-scheduled                                :foreground green)
   (org-scheduled-previously                     :foreground orange)
   (org-scheduled-today                          :foreground green)
   (org-special-keyword                          :foreground orange)
   (org-table                                    :foreground magenta)
   (org-todo                                     :foreground red)
   (org-upcoming-deadline                        :foreground orange)
   (org-warning                                  :foreground orange :weight bold)

;;;; show-paren-mode
   (show-paren-match                             :inverse-video t)
   (show-paren-mismatch                          :background red :inverse-video t)

   ))

;; Anything leftover that doesn't fall neatly into a face goes here.
(let ((bg      (plist-get grayscale-theme-colors :bg))
      (fg      (plist-get grayscale-theme-colors :fg))
      (red     (plist-get grayscale-theme-colors :red))
      (green   (plist-get grayscale-theme-colors :green))
      (yellow  (plist-get grayscale-theme-colors :yellow))
      (blue    (plist-get grayscale-theme-colors :blue))
      (magenta (plist-get grayscale-theme-colors :magenta))
      (cyan    (plist-get grayscale-theme-colors :cyan)))
  (custom-theme-set-variables
   'grayscale
   `(ansi-color-names-vector
     ;; black, base08, base0B, base0A, base0D, magenta, cyan, white
     [,bg ,red ,green ,yellow ,blue ,magenta ,cyan ,fg])
   `(ansi-term-color-vector
     ;; black, base08, base0B, base0A, base0D, magenta, cyan, white
     [unspecified ,bg ,red ,green ,yellow ,blue ,magenta ,cyan ,fg])))

;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))

(provide 'grayscale-theme)

;;; grayscale-theme.el ends here
