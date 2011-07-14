(defgroup cpan-changes '((jit-lock custom-group))
  "Mode for editing CPAN module changelogs"
  :group 'faces)

(defgroup cpan-changes-faces nil
  "Faces for highlighting CPAN Module changelogs"
  :prefix "cpan-changes-"
  :group 'cpan-changes)

(defface cpan-changes-date-face
  '((t (:inherit font-lock-string-face)))
  "Face used to highlight dates in CPAN changelogs."
  :group 'cpan-changes-faces)

(defface cpan-changes-version-face
  '((t (:inherit font-lock-keyword-face)))
  "Face used to highlight versions in CPAN changelogs."
  :group 'cpan-changes-faces)

(defface cpan-changes-grouping-name-face
  '((t (:inherit font-lock-variable-name-face)))
  "Face used to highlight versions in CPAN changelogs."
  :group 'cpan-changes-faces)

(defface cpan-changes-preamble-face
  '((t (:inherit font-lock-string-face)))
  "Face used to highlight preambles in CPAN changelogs."
  :group 'cpan-changes-faces)

(defconst cpan-changes-font-lock-keywords-1
  ;; I'm clearly doing something wrong here. Elisp regexen can't be *that* bad
  (let ((version-re
         (concat
          "undef"
          "\\|"
          "\\(?:"  ;; lax decimal version
            "\\(?:[0-9]+\\)" "\\(?:\.\\|\\(?:\.[0-9]+\\)\\(?:_[0-9]+\\)?\\)?"
            "\\|"
            "\\(?:\.[0-9]+\\)\\(?:_[0-9]+\\)?"
          "\\)"
          "\\|"
          "\\(?:"  ;; lax dotted decimal version
            "v[0-9]+\\(?:\\(?:\.[0-9]+\\)+\\(?:_[0-9]+\\)?\\)?"
            "\\|"
            "\\(?:[0-9]+\\)?\\(?:\.[0-9]+\\)\\{2,\\}\\(?:_[0-9]+\\)?"
          "\\)")))
    (append
     `((,(concat
          "^\\(" version-re "\\)"
          " +"
          "\\("  ;; W3CDTF
           "\\(?:[0-9]\\{4\\}\\)"          ;; Year
            "\\(?:-\\(?:[0-9]\\{2\\}\\)"   ;; -Month
             "\\(?:-\\(?:[0-9]\\{2\\}\\)"  ;; -Day
              "\\(?:T"
               "\\(?:[0-9]\\{2\\}\\):\\(?:[0-9]\\{2\\}\\)"  ;; Hour:Minute
               "\\(?:"
                     ":\\(?:[0-9]\\{2\\}\\)"  ;; :Second
                     "\\(?:\.[0-9]+\\)?"      ;; .Fractional_Second
               "\\)?"
               "\\(?:Z"  ;; UTC
                 "\\|[+-][0-9]\\{2\\}:[0-9]\\{2\\}"  ;; Hour:Minute TZ offset
                 "\\(?::[0-9]\\{2\\}\\)?"            ;; :Second TZ offset
               "\\)?\\)?\\)?\\)?"
          "\\)$")
        (1 'cpan-changes-version-face)
        (2 'cpan-changes-date-face)))
     `((,(concat "\\`\\(.*?\\)" version-re)
        (1 'cpan-changes-preamble-face)))
     '(("^ +\\[\\(.+\\)\\]"
        (1 'cpan-changes-grouping-name-face))))))

(defvar cpan-changes-font-lock-keywords cpan-changes-font-lock-keywords-1)

;;;###autoload
(define-derived-mode cpan-changes-mode text-mode "CPAN-Changes"
  "Major mode for editing CPAN module changelogs"
  (setq left-margin 2
        fill-column 74
        indent-tabs-mode nil
        tab-width 2
        show-trailing-whitespace t)
;;  (use-local-map cpan-changes-map)
  (setq font-lock-multiline t)
  (setq font-lock-defaults '(cpan-changes-font-lock-keywords t)))

(provide 'cpan-changes)
