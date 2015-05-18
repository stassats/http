(asdf:defsystem http
  :name "http"
  :serial t
  :depends-on (drakma flexi-streams)
  :components ((:file "packages")
               (:file "http")))
