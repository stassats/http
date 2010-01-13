
(in-package #:http)

(defparameter *stream* nil)

(defun request (url &key parameters reuse-connection)
  (multiple-value-bind (body code headers uri stream must-close reason-phrase)
      (drakma:http-request url
                           :parameters parameters
                           :additional-headers '(("Accept-Encoding" . "gzip"))
                           :keep-alive reuse-connection
                           :close (not reuse-connection)
                           :stream (when (and reuse-connection
                                              (streamp *stream*)
                                              (open-stream-p *stream*))
                                     *stream*))
    (when reuse-connection
      (setf *stream*
            (unless must-close
              stream)))
    (cond ((/= code 200) (error "http error ~a." code))
          ((equal "gzip" (cdr (assoc :content-encoding headers)))
           (let ((result (chipz:decompress nil 'chipz:gzip body)))
             (map-into (make-string (length result))
                       #'code-char result)))
          (t body))))
