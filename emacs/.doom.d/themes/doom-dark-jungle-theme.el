;;; doom-dark-jungle-theme.el --- Dark Jungle -*- no-byte-compile: t; -*-
;;
;; Palette: deep jungle floor (#0A1A15) → filtered canopy light (#6CD4A0)
;; Five greens with a lush blue-green shift in the darker tones.

(require 'doom-themes)

(defgroup doom-dark-jungle-theme nil
  "Options for the doom-dark-jungle theme."
  :group 'doom-themes)

(def-doom-theme doom-dark-jungle
  "A dark theme inspired by the deep jungle floor."

  ;; name        default   256         16
  ((bg         '("#0A1A15" "black"     "black"        ))
   (fg         '("#A8D4BC" "#afd7af"   "brightwhite"  ))

   (bg-alt     '("#061210" "black"     "black"        ))
   (base0      '("#040D0A" "black"     "black"        ))
   (base1      '("#071512" "#080808"   "black"        ))
   (base2      '("#0D2018" "#1c1c1c"   "black"        ))
   (base3      '("#152E24" "#262626"   "black"        ))
   (base4      '("#1A3028" "#303030"   "black"        ))
   (base5      '("#234A37" "#3a3a3a"   "brightblack"  ))
   (base6      '("#3A7A5A" "#5f875f"   "brightblack"  ))
   (base7      '("#6CD4A0" "#87d7af"   "brightgreen"  ))
   (base8      '("#D4EDE4" "#d7ffd7"   "white"        ))

   (grey       base4)
   (red        '("#C05858" "#d75f5f"   "red"          ))
   (orange     '("#B07040" "#af875f"   "brightred"    ))
   (green      '("#4CAF82" "#5faf87"   "green"        ))
   (teal       '("#3A8A6A" "#5f8787"   "brightgreen"  ))
   (yellow     '("#8DAE3A" "#87af5f"   "yellow"       ))
   (blue       '("#4A90B0" "#5fafaf"   "brightblue"   ))
   (dark-blue  '("#1A3A50" "#005f87"   "blue"         ))
   (magenta    '("#7A5CAA" "#875faf"   "brightmagenta"))
   (violet     '("#9A7ACA" "#af87d7"   "magenta"      ))
   (cyan       '("#6CD4A0" "#87d7af"   "brightcyan"   ))
   (dark-cyan  '("#1E7A4A" "#005f5f"   "cyan"         ))

   ;; face variables
   (highlight      cyan)
   (vertical-bar   base2)
   (selection      base4)
   (builtin        cyan)
   (comments       base6)
   (doc-comments   teal)
   (constants      yellow)
   (functions      green)
   (keywords       cyan)
   (methods        green)
   (operators      fg)
   (type           yellow)
   (strings        base8)
   (variables      fg)
   (numbers        orange)
   (region         base4)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   ;; modeline
   (modeline-fg            fg)
   (modeline-fg-alt        base6)
   (modeline-bg            base3)
   (modeline-bg-inactive   base2)
   (modeline-bg-l          dark-cyan)
   (modeline-bg-inactive-l base2))

  ;; faces
  (;;;; Modeline
   (mode-line          :background modeline-bg    :foreground modeline-fg)
   (mode-line-inactive :background modeline-bg-inactive :foreground modeline-fg-alt)

   ;;;; Cursor
   (cursor             :background cyan)

   ;;;; Org blocks
   (org-block            :background base2)
   (org-block-begin-line :foreground dark-cyan :slant 'italic)

   ;;;; Treemacs
   (treemacs-root-face   :foreground cyan :bold t)

   ;;;; Magit
   (magit-branch-local   :foreground cyan)
   (magit-branch-remote  :foreground green))

  ;; variables
  ())
