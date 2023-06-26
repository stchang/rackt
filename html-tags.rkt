#lang racket

;; This module exports all common HTML tags
;; as strings with bindings set to their respective
;; tag names. e.g
;; (define p "p")
;; (define div "div")

(require (for-syntax racket/string
                     racket/syntax
                     syntax/stx
                     syntax/parse))

(provide (all-defined-out))

;; A macro to bind a string representation of an indefinite
;; number of provided symbols to themselves
;; ex: (define-symbols-as-strings p div)
;; -> (define p "p")
;; -> (define div "div")
(define-syntax (define-symbols-as-strings stx)
  (syntax-parse stx
   [(_)
    #'(void)]
   [(_ curr-var other-vars ...)
    (with-syntax ([var-str (symbol->string (syntax->datum #'curr-var))])
        #'(begin
            (define curr-var var-str)
            (define-symbols-as-strings other-vars ...)
        ))]))

; (define-syntax (bind-tokens-to-strings stx)
;   (syntax-parse stx
;    [(_ filename)
;     (with-input-from-file (in (syntax->datum #'filename))
;       (displayln (port->string in)))]))

; (bind-tokens-to-strings "html-tags.txt")

(define-syntax (read-file stx)
  (syntax-parse stx
   [(_ filename-stx)
     (define filename (syntax->datum #'filename-stx))
     (define MAX-CHARS 999999)
     (define file-contents (read-string MAX-CHARS (open-input-file filename)))
     (with-syntax ([token-list (string-split file-contents)])
        #''token-list
     )
     ]))

(displayln (read-file "html-tags.txt"))

; (displayln (read-string 1000000 (open-input-file "html-tags.txt")))

(define-symbols-as-strings a abbr acronym address applet area article aside audio b base basefont bdi bdo big blockquote body br button canvas caption center cite code col colgroup data datalist dd del details dfn dialog dir div dl dt em embed fieldset figcaption figure font footer form frame frameset h1 h2 h3 h4 h5 h6 head header hgroup hr html i iframe img input ins kbd label legend li link main map mark meta meter nav noframes noscript object ol optgroup option output p param picture pre progress q rp rt ruby s samp script section select small source span strike strong style sub summary sup table tbody td template textarea tfoot th thead time title tr track tt u ul var video wbr)

;; ;; test case
;; (define-symbols-as-strings p div h1 h2)
;; (displayln p)
;; (displayln div)