;;; cl-webkit2-tests.asd --- a suite of unit tests for cl-webkit2

;; This file is part of cl-webkit.
;;
;; cl-webkit is free software; you can redistribute it and/or modify
;; it under the terms of the MIT license.
;; See `COPYING' in the source distribution for details.

;;; Code:

(in-package #:webkit2-tests)

;;; Main entry point

(defun run-tests ()
  "Run all unit tests for CL-WEBKIT2."
  (lisp-unit:run-tests))

;;; Utilities

(lisp-unit:define-test medial->delim-nonmedial
  (lisp-unit:assert-equal
   "foobar"
   (webkit2::medial->delim "foobar")))

(lisp-unit:define-test medial->delim-single-uppers
  (lisp-unit:assert-equal
   "web-view"
   (webkit2::medial->delim "WebView")))

(lisp-unit:define-test medial->delim-skip-prefix
  (lisp-unit:assert-equal
   "web-view"
   (webkit2::medial->delim "WebKitWebView" :start 6)))

(lisp-unit:define-test medial->delim-to-upcase
  (lisp-unit:assert-equal
   "WEB-VIEW"
   (webkit2::medial->delim "WebView" :norm-case #'char-upcase)))

(lisp-unit:define-test medial->delim-multi-uppers
  (lisp-unit:assert-equal
   "url-response"
   (webkit2::medial->delim "URLResponse")))

(lisp-unit:define-test medial->delim-idem
  (lisp-unit:assert-equal
   "web-view"
   (webkit2::medial->delim (webkit2::medial->delim "WebView"))))

(lisp-unit:define-test foo->symbol-upper-string
  (lisp-unit:assert-equal
   "FOO"
   (symbol-name (webkit2::foo->symbol "FOO"))))

(lisp-unit:define-test foo->symbol-lower-string
  (lisp-unit:assert-equal
   "FOO"
   (symbol-name (webkit2::foo->symbol "foo"))))

(lisp-unit:define-test foo->symbol-symbol
  (lisp-unit:assert-equal
   "FOO"
   (symbol-name (webkit2::foo->symbol 'foo))))

(lisp-unit:define-test foo->symbol-cat-mixed
  (lisp-unit:assert-equal
   "WEBKIT-WEB-VIEW"
   (symbol-name (webkit2::foo->symbol "webkit" "-" 'web "-" "VIEW"))))

(lisp-unit:define-test foo->symbol-print-downcase
  (lisp-unit:assert-equal
   "FOO"
   (symbol-name
    (let ((*print-case* :downcase))
      (webkit2::foo->symbol 'foo)))))

;;; Defining macros

(lisp-unit:define-test define-webkit-class-example-1
  (lisp-unit:assert-expands
   '(webkit2::define-g-object-class* "WebKitWebView" webkit2::webkit-web-view
     (:superclass gtk:gtk-widget
      :export t
      :interfaces nil
      :type-initializer "webkit_web_view_get_type")
     (("zoom-level" "gdouble")))
   (webkit2::define-webkit-class "WebKitWebView" (:superclass gtk:gtk-widget)
     (("zoom-level" "gdouble")))))

(lisp-unit:define-test define-g-object-class*-example-1
  (lisp-unit:assert-expands
   '(gobject:define-g-object-class "WebKitWebView" webkit-web-view
     (:superclass gtk:gtk-widget
      :export t
      :interfaces nil
      :type-initializer "webkit_web_view_get_type")
     ((webkit2::zoom-level webkit2::webkit-web-view-zoom-level "zoom-level" "gdouble" t t)))
   (webkit2::define-g-object-class* "WebKitWebView" webkit-web-view
     (:superclass gtk:gtk-widget
      :type-initializer "webkit_web_view_get_type")
     (("zoom-level" "gdouble" t t)))))
