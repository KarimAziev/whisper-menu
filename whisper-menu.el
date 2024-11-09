;;; whisper-menu.el --- Transient menu for whisper -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Karim Aziiev <karim.aziiev@gmail.com>

;; Author: Karim Aziiev <karim.aziiev@gmail.com>
;; URL: https://github.com/KarimAziev/whisper-menu
;; Version: 0.1.0
;; Keywords: tools
;; Package-Requires: ((emacs "28.1") (transient "0.6.0"))
;; SPDX-License-Identifier: GPL-3.0-or-later

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides a transient menu for configuring and interacting with
;; the Whisper API in Emacs within transient menu.

;;; Code:

(require 'whisper)
(require 'transient)

(defcustom whisper-menu-align-column 50
  "Column alignment for menu entries.

Specifies the column at which menu items should be aligned in the whisper menu.

The value is an integer representing the column number.

Menu descriptions are truncated or padded with spaces to ensure alignment at
this column, enhancing readability and consistency of the menu display.

Adjusting this value can help accommodate different screen sizes or personal
preferences for menu layout."
  :group 'whisper-menu
  :type 'integer)


(defcustom whisper-menu-language-choices '("auto" "en")
  "Available language options for Whisper menu translations.

A list of language codes representing the available options for the Whisper
menu's language settings.

This variable can also be configured interactively by the commands
`whisper-menu-add-language-choice' and `whisper-menu-remove-language-choice'.

Each list element is a string that corresponds to the ISO code for that
language.

The \"auto\" option can be used to automatically detect the language based on
the input text.

This list is used to configure the language setting for the Whisper menu,
allowing for dynamic language selection based on user preference or text
content.

Users can select their desired language from this list when interacting
with the Whisper menu functionalities."
  :group 'whisper-menu
  :type '(set :greedy t
          (const :tag "auto" "auto")
          (const :tag "english" "en")
          (const :tag "chinese" "zh")
          (const :tag "german" "de")
          (const :tag "spanish" "es")
          (const :tag "russian" "ru")
          (const :tag "korean" "ko")
          (const :tag "french" "fr")
          (const :tag "japanese" "ja")
          (const :tag "portuguese" "pt")
          (const :tag "turkish" "tr")
          (const :tag "polish" "pl")
          (const :tag "catalan" "ca")
          (const :tag "dutch" "nl")
          (const :tag "arabic" "ar")
          (const :tag "swedish" "sv")
          (const :tag "italian" "it")
          (const :tag "indonesian" "id")
          (const :tag "hindi" "hi")
          (const :tag "finnish" "fi")
          (const :tag "vietnamese" "vi")
          (const :tag "hebrew" "iw")
          (const :tag "ukrainian" "uk")
          (const :tag "greek" "el")
          (const :tag "malay" "ms")
          (const :tag "czech" "cs")
          (const :tag "romanian" "ro")
          (const :tag "danish" "da")
          (const :tag "hungarian" "hu")
          (const :tag "tamil" "ta")
          (const :tag "norwegian" "no")
          (const :tag "thai" "th")
          (const :tag "urdu" "ur")
          (const :tag "croatian" "hr")
          (const :tag "bulgarian" "bg")
          (const :tag "lithuanian" "lt")
          (const :tag "latin" "la")
          (const :tag "maori" "mi")
          (const :tag "malayalam" "ml")
          (const :tag "welsh" "cy")
          (const :tag "slovak" "sk")
          (const :tag "telugu" "te")
          (const :tag "persian" "fa")
          (const :tag "latvian" "lv")
          (const :tag "bengali" "bn")
          (const :tag "serbian" "sr")
          (const :tag "azerbaijani" "az")
          (const :tag "slovenian" "sl")
          (const :tag "kannada" "kn")
          (const :tag "estonian" "et")
          (const :tag "macedonian" "mk")
          (const :tag "breton" "br")
          (const :tag "basque" "eu")
          (const :tag "icelandic" "is")
          (const :tag "armenian" "hy")
          (const :tag "nepali" "ne")
          (const :tag "mongolian" "mn")
          (const :tag "bosnian" "bs")
          (const :tag "kazakh" "kk")
          (const :tag "albanian" "sq")
          (const :tag "swahili" "sw")
          (const :tag "galician" "gl")
          (const :tag "marathi" "mr")
          (const :tag "punjabi" "pa")
          (const :tag "sinhala" "si")
          (const :tag "khmer" "km")
          (const :tag "shona" "sn")
          (const :tag "yoruba" "yo")
          (const :tag "somali" "so")
          (const :tag "afrikaans" "af")
          (const :tag "occitan" "oc")
          (const :tag "georgian" "ka")
          (const :tag "belarusian" "be")
          (const :tag "tajik" "tg")
          (const :tag "sindhi" "sd")
          (const :tag "gujarati" "gu")
          (const :tag "amharic" "am")
          (const :tag "yiddish" "yi")
          (const :tag "lao" "lo")
          (const :tag "uzbek" "uz")
          (const :tag "faroese" "fo")
          (const :tag  "haitian creole" "ht")
          (const :tag "pashto" "ps")
          (const :tag "turkmen" "tk")
          (const :tag "nynorsk" "nn")
          (const :tag "maltese" "mt")
          (const :tag "sanskrit" "sa")
          (const :tag "luxembourgish" "lb")
          (const :tag "myanmar" "my")
          (const :tag "tibetan" "bo")
          (const :tag "tagalog" "tl")
          (const :tag "malagasy" "mg")
          (const :tag "assamese" "as")
          (const :tag "tatar" "tt")
          (const :tag "hawaiian" "haw")
          (const :tag "lingala" "ln")
          (const :tag "hausa" "ha")
          (const :tag "bashkir" "ba")
          (const :tag "javanese" "jw")
          (const :tag "sundanese" "su")
          (repeat :inline t
           (string))))

(defcustom whisper-menu-saveable-variables '(whisper-language
                                             whisper-model
                                             whisper-translate
                                             whisper-menu-language-choices)
  "List of Whisper-related variables eligible for saving.

This includes variables that can be saved using the command
`whisper-menu-save-variables'.

The default variables include settings for language, model, translation and
language choices for the whisper menu."
  :group 'whisper-menu
  :type '(set :greedy t
          (const whisper-language)
          (const whisper-model)
          (const whisper-translate)
          (const whisper-use-threads)
          (const whisper-insert-text-at-point)
          (const whisper-return-cursor-to-start)
          (const whisper-menu-language-choices)
          (repeat :inline t
           (symbol))))

(defcustom whisper-menu-language-completing-read-threshold 4
  "Minimum number of languages to choose with `completing-read'."
  :type 'integer
  :group 'whisper-menu)


(defclass whisper-menu-transient-language (transient-infix)
  ((format :initform " %k %d %v"))
  "Class used for switching the language.")

(cl-defmethod transient-init-value ((this whisper-menu-transient-language))
  "Set `whisper-language' based on object's value or default choice.

Argument THIS is an instance created with the function
`whisper-menu-transient-language'."
  (let ((value
         (cond ((and (slot-boundp this 'value)
                     (oref this value))
                (oref this value))
               (t (or whisper-language (car whisper-menu-language-choices))))))
    (whisper-menu-set-variable 'whisper-language value)
    (oset this value value)))

(cl-defmethod transient-format-value ((this whisper-menu-transient-language))
  "Format and display selected language value with visual cues.

Argument THIS is an instance created with the function
`whisper-menu-transient-language'."
  (let ((value (transient-infix-value this)))
    (if (> (length whisper-menu-language-choices)
           whisper-menu-language-completing-read-threshold)
        (propertize
         (substring-no-properties
          value)
         'face
         'transient-value)
      (concat
       (propertize "[" 'face 'transient-inactive-value)
       (mapconcat
        (lambda (choice)
          (propertize (substring-no-properties choice) 'face
                      (if (string= choice value)
                          'transient-value
                        'transient-inactive-value)))
        (append (list value)
                (remove value whisper-menu-language-choices))
        (propertize "|" 'face 'transient-inactive-value))
       (propertize "]" 'face 'transient-inactive-value)))))

(cl-defmethod transient-infix-read ((this whisper-menu-transient-language))
  "Cycle through language choices or prompt for selection based on threshold.

Argument THIS is an instance created with the function
`whisper-menu-transient-language'."
  (let* ((choices whisper-menu-language-choices)
         (current-idx (or (seq-position choices (transient-infix-value this)) -1))
         (next-idx (% (1+ current-idx)
                      (length choices)))
         (next-choice
          (if (> (length choices)
                 whisper-menu-language-completing-read-threshold)
              (whisper-menu--read-language "Language: " choices)
            (nth next-idx choices))))
    (whisper-menu-set-variable 'whisper-language next-choice)
    next-choice))

(cl-defmethod transient-infix-value ((this whisper-menu-transient-language))
  "Return current language choice from `whisper-menu-language-choices'.

Argument THIS is an instance created with the function
`whisper-menu-transient-language'."
  (let* ((choices whisper-menu-language-choices)
         (current-idx (or (seq-position choices (oref this value)) -1)))
    (nth current-idx choices)))

(transient-define-infix whisper-menu--language-source ()
  :class 'whisper-menu-transient-language
  :description "language"
  :argument "-l")


(defun whisper-menu--get-all-languages ()
  "Combine predefined and custom language choices, removing duplicates."
  (delete-dups (append
                whisper-menu-language-choices
                (mapcar
                 (pcase-lambda (`(,_c ,_k ,_label ,value))
                   value)
                 (butlast (cdddr (get 'whisper-menu-language-choices
                                      'custom-type))
                          1)))))

(defun whisper-menu-get-modified-variables ()
  "Return modified variables from `whisper-menu-saveable-variables'."
  (seq-filter (lambda (var)
                (and (custom-variable-p var)
                     (not
                      (equal (symbol-value var)
                             (whisper-menu-get-custom-value var)))))
              whisper-menu-saveable-variables))

(defun whisper-menu-save-variables ()
  "Save value of modified variables from `whisper-menu-saveable-variables'."
  (interactive)
  (dolist (var (whisper-menu-get-modified-variables))
    (whisper-menu-set-variable var (symbol-value var)
                               t)))


(defun whisper-menu-add-language-choice (&optional arg)
  "Add a language choice to Whisper menu's language options.

Optional argument ARG is a prefix argument, which if non-nil, saves the variable
`whisper-menu-language-choices' value persistently."
  (interactive "P")
  (let* ((value
          (whisper-menu--read-language "Add language: "
                                       (seq-difference
                                        (whisper-menu--get-all-languages)
                                        whisper-menu-language-choices)))
         (choices (append whisper-menu-language-choices (list value))))
    (whisper-menu-set-variable 'whisper-menu-language-choices choices arg)))


(defun whisper-menu-remove-language-choice (&optional arg)
  "Remove a language choice from Whisper menu options.

Optional argument ARG is a prefix argument, which if non-nil, saves the variable
`whisper-menu-language-choices' value persistently."
  (interactive "P")
  (let* ((value
          (whisper-menu--read-language "Remove language: "
                                       whisper-menu-language-choices))
         (choices (remove value whisper-menu-language-choices)))
    (unless choices
      (user-error "At least one language should be specified"))
    (while (not (member whisper-language choices))
      (whisper-menu-set-variable 'whisper-language
                                 (whisper-menu--read-language
                                  "Set language: "
                                  choices)
                                 arg))
    (whisper-menu-set-variable 'whisper-menu-language-choices choices arg)))

(defun whisper-menu--read-language (prompt &optional langs)
  "PROMPT user to select a language with completion and annotations.

Argument PROMPT is a string displayed to the user when asking for input.

Optional argument LANGS is a list of language codes to restrict the selection."
  (let* ((alist (mapcar
                 (pcase-lambda (`(,_c ,_k ,label ,value))
                   (cons value label))
                 (butlast (cdddr (get 'whisper-menu-language-choices
                                      'custom-type))
                          1)))
         (annotf (lambda (str)
                   (concat " " (or (cdr (assoc str alist)) "")))))
    (completing-read prompt
                     (lambda (str pred action)
                       (if (eq action 'metadata)
                           `(metadata
                             (annotation-function . ,annotf))
                         (complete-with-action action (or langs alist) str
                                               pred))))))



(defun whisper-menu--format-toggle-description (description value &optional
                                                            on-label off-label
                                                            left-separator
                                                            right-separator
                                                            divider)
  "Format toggle DESCRIPTION with VALUE indication and optional labels.

Argument DESCRIPTION is the text description of the toggle.

Argument VALUE is a boolean indicating the toggle's state.

Optional argument ON-LABEL is the label shown when VALUE is non-nil. It defaults
to \"+\".

Optional argument OFF-LABEL is the label shown when VALUE is nil. It defaults to
\"-\".

Optional argument LEFT-SEPARATOR is the character used before the ON-LABEL or
OFF-LABEL. It defaults to \"[\".

Optional argument RIGHT-SEPARATOR is the character used after the ON-LABEL or
OFF-LABEL. It defaults to \"]\".

Optional argument DIVIDER is the character used to fill space. It defaults to 32
\\=(space character)."
  (let* ((description (or description ""))
         (face (if value 'success 'transient-inactive-value)))
    (concat
     (truncate-string-to-width description whisper-menu-align-column
                               nil (or divider ?\s) t)
     (or left-separator "[")
     (if value
         (propertize
          (or on-label "+")
          'face
          face)
       (propertize
        (or off-label "-")
        'face
        face))
     (or right-separator "]"))))


(defmacro whisper-menu-csetq (variable value)
  "Set VARIABLE to VALUE, using variable's custom setter or `set-default'.

Argument VARIABLE is the custom variable to set.

Argument VALUE is the new value for the VARIABLE."
  `(funcall (or (get ',variable 'custom-set) 'set-default) ',variable ,value))

(defun whisper-menu-get-custom-value (sym)
  "Return the saved or standard value of the symbol SYM.

Argument SYM is a symbol whose custom value is retrieved."
  (or
   (when (car (get sym 'saved-value))
     (eval (car (get sym 'saved-value))))
   (eval (car (get sym 'standard-value)))))

(defun whisper-menu-set-variable (var value &optional save comment)
  "Set or SAVE a variable VAR to VALUE, optionally with COMMENT.

Argument VAR is the variable to set.

Argument VALUE is the new value for the variable VAR.

Optional argument SAVE is a boolean; if non-nil, the variable is saved to the
user's custom file.

Optional argument COMMENT is a string used as a comment when saving the
variable. It defaults to \"Saved by whisper-menu.\"."
  (let ((customp (custom-variable-p var)))
    (if (and save customp)
        (customize-save-variable var value
                                 (or comment "Saved by whisper-menu."))
      (if customp
          (funcall (or (get var 'custom-set) 'set-default) var value)
        (set-default var value)))))

(defun whisper-menu-set-use-threads (&optional arg)
  "Set the number of threads for `whisper-menu', prompting user for input.

Optional argument ARG is a prefix argument, which if non-nil, saves the variable
value persistently."
  (interactive "P")
  (let ((value (read-number "Number of threads (0 for nil): "
                            whisper-use-threads)))
    (whisper-menu-set-variable 'whisper-use-threads
                               (unless (zerop value)
                                 value)
                               arg)))

(defun whisper-menu-toggle-translate (&optional arg)
  "Toggle the `whisper-translate' variable on or off.

Optional argument ARG is a prefix argument, which if non-nil, saves the variable
value persistently."
  (interactive "P")
  (whisper-menu-set-variable 'whisper-translate (not whisper-translate) arg))

(defun whisper-menu-toggle-insert-text-at-point (&optional arg)
  "Toggle the state of `whisper-insert-text-at-point' variable.

Optional argument ARG is a prefix argument, which if non-nil, saves the variable
value persistently."
  (interactive "P")
  (whisper-menu-set-variable 'whisper-insert-text-at-point
                             (not
                              whisper-insert-text-at-point)
                             arg))

(defun whisper-menu-toggle-return-cursor-to-start (&optional arg)
  "Toggle the state of `whisper-return-cursor-to-start' variable.

Optional argument ARG is a prefix argument, which if non-nil, saves the variable
value persistently."
  (interactive "P")
  (whisper-menu-set-variable 'whisper-return-cursor-to-start
                             (not
                              whisper-return-cursor-to-start)
                             arg))

(defun whisper-menu-set-model (&optional arg)
  "Set the `whisper-model' variable to a user-selected model size.

The optional argument ARG determines whether the setting should be saved."
  (interactive "P")
  (let ((value (completing-read "Model: " '("tiny" "base" "small" "medium"
                                            "large"))))
    (whisper-menu-set-variable 'whisper-model value arg)))


;;;###autoload (autoload 'whisper-menu "whisper-menu" nil t)
(transient-define-prefix whisper-menu ()
  "Menu with Whisper commands and settings.

Settings can be saved using the `whisper-menu-save-variables' command or by
executing a suffix command with a prefix argument.

The command `whisper-menu-save-variables' saves the values of modified variables
as defined in the `whisper-menu-saveable-variables' customizable variable."
  :transient-suffix #'transient--do-stay
  :refresh-suffixes t
  [["Settings"
    ("r" whisper-menu-set-use-threads :description
     (lambda ()
       (concat "Number of threads to use "
               (propertize
                (format "%s" whisper-use-threads)
                'face
                'transient-value))))
    ("t" whisper-menu-toggle-translate
     :description
     (lambda ()
       (whisper-menu--format-toggle-description
        "Toggle translate"
        whisper-translate)))
    ("c" whisper-menu-toggle-return-cursor-to-start
     :description
     (lambda ()
       (whisper-menu--format-toggle-description
        "Toggle return-cursor-to-start"
        whisper-return-cursor-to-start)))
    ("i" whisper-menu-toggle-insert-text-at-point
     :description
     (lambda ()
       (whisper-menu--format-toggle-description
        "Toggle insert-text-at-point"
        whisper-insert-text-at-point)))
    ("l" whisper-menu--language-source)
    ("+" "Add language choice" whisper-menu-add-language-choice)
    ("-" "Remove language choice" whisper-menu-remove-language-choice)
    ("m" whisper-menu-set-model :description (lambda ()
                                               (concat "model "
                                                       (propertize
                                                        (substring-no-properties
                                                         whisper-model)
                                                        'face
                                                        'transient-value))))]]
  ["Actions"
   ("s" whisper-menu-save-variables
    :inapt-if-not whisper-menu-get-modified-variables
    :description
    (lambda ()
      (concat "Save modified variables "
              (mapconcat (lambda (it)
                           (propertize
                            (substring-no-properties (symbol-name it))
                            'face
                            'transient-value))
                         (whisper-menu-get-modified-variables)
                         ", "))))
   ("RET" whisper-run
    :description
    (lambda ()
      (concat "Transcribe/translate audio "
              (when-let* ((status
                          (cond ((process-live-p whisper--transcribing-process)
                                 "transcribing")
                                ((process-live-p whisper--recording-process)
                                 "recording")
                                ((and
                                  (buffer-live-p whisper--compilation-buffer)
                                  (process-live-p
                                   (get-buffer-process
                                    whisper--compilation-buffer)))
                                 "installing"))))
                (propertize status 'face 'transient-value))))
    :transient nil)
   ("f" "Transcribe/translate file" whisper-file :transient nil)])


(provide 'whisper-menu)
;;; whisper-menu.el ends here