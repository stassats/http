
(in-package #:http)

(defparameter *stream* nil)

(defun request (url &optional parameters)
  (multiple-value-bind (body code headers uri stream must-close reason-phrase)
      (drakma:http-request url
                           :parameters parameters
                           :additional-headers '(("Accept-Encoding" . "gzip"))
                           ;; :keep-alive t
                           ;; :close nil
                           ;; :stream *stream*
                           )
    ;; (setf *stream*
    ;;       (unless must-close
    ;;         stream))
    (cond ((/= code 200) (error "http error ~a." code))
          ((equal "gzip" (cdr (assoc :content-encoding headers)))
           (let ((result (chipz:decompress nil 'chipz:gzip body)))
             (map-into (make-string (length result))
                       #'code-char result)))
          (t body))))
