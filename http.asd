(asdf:defsystem http
  :name "http"
  :serial t
  :depends-on (drakma chipz flexi-streams)
  :components ((:file "packages")
               (:file "http")))
