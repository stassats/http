
(in-package :http)

(defparameter *stream* nil)

(defun process-body (body headers binary)
  (let* ((charset
           (drakma:parameter-value "charset"
                                   (nth-value 2
                                              (drakma:get-content-type headers))))
         (external-format (if charset
                              (or (find-symbol (string-upcase charset)
                                               :keyword)
                                  :utf-8)
                              :utf-8)))
    (cond (binary
           body)
          ((not (stringp body))
           (flexi-streams:octets-to-string body
                                           :external-format external-format))
          (t
           body))))

(defun request (url &key parameters
                         reuse-connection
                         binary
                         cookie
                         (method :get)
                         form-data
                         content
                         (content-type "application/x-www-form-urlencoded")
                         (content-length nil content-length-provided)
                         gzip
                         accept-language
                         (user-agent :drakma))
  (multiple-value-bind (body code headers uri stream must-close)
      (apply #'drakma:http-request
             url
             :method method
             :parameters parameters
             :additional-headers `(,@(and gzip
                                          '(("Accept-Encoding" . "gzip")))
                                   ,@(and accept-language
                                          `(("Accept-Language" . ,accept-language))))
             :keep-alive reuse-connection
             :close (not reuse-connection)
             :stream (when (and reuse-connection
                                (streamp *stream*)
                                (open-stream-p *stream*))
                       *stream*)
             :decode-content t
             :force-binary binary
             :user-agent :firefox
             :cookie-jar cookie
             :form-data form-data
             :content content
             :content-type content-type
             :user-agent user-agent
             (and content-length-provided
                  `(:content-length ,content-length)))
    (when reuse-connection
      (setf *stream*
            (unless must-close
              stream)))
    (values
     (cond ((/= code 200 302)
            (error "http error ~a. ~a" code
                   (process-body body headers binary)))
           (t
            (process-body body headers binary)))
     uri)))
