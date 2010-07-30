
(in-package #:http)

(defparameter *stream* nil)

(defun ungzip (body headers binary)
  (let ((charset
         (drakma:parameter-value "charset"
                                 (nth-value 2
                                            (drakma:get-content-type headers))))
        (decompressed (chipz:decompress nil 'chipz:gzip body)))
    (if binary
        decompressed
        (flexi-streams:octets-to-string decompressed
                                        :external-format
                                        (intern (string-upcase charset)
                                                :keyword)))))


(defun request (url &key parameters reuse-connection binary)
  (multiple-value-bind (body code headers uri stream must-close reason-phrase)
      (drakma:http-request url
                           :parameters parameters
                           :additional-headers '(("Accept-Encoding" . "gzip"))
                           :keep-alive reuse-connection
                           :close (not reuse-connection)
                           :stream (when (and reuse-connection
                                              (streamp *stream*)
                                              (open-stream-p *stream*))
                                     *stream*)
                           :force-binary binary
                           :user-agent :firefox)
    (declare (ignore reason-phrase))
    (when reuse-connection
      (setf *stream*
            (unless must-close
              stream)))
    (values
     (cond ((/= code 200) (error "http error ~a." code))
           ((equal "gzip" (drakma:header-value :content-encoding headers))
            (ungzip body headers binary))
           (t body))
     uri)))
