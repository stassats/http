;;; -*- Mode: Lisp -*-

;;; This software is in the public domain and is
;;; provided with absolutely no warranty.

(in-package #:movies-clim)

(define-application-frame movies ()
  ((current-movie :initform nil)
   interaction-pane
   name-pane)
  (:pointer-documentation t)		;Added by moore
  (:panes
   (interactor :interactor)
   (movie :application
          :incremental-redisplay t
          :display-function 'display-movie)
   (movies :application
          :incremental-redisplay t
          :display-function 'display-movies))
  (:layouts
   (default
       (vertically ()
         (horizontally ()
           movie movies)
         interactor))))

;;; Presentations
(define-presentation-type movie ())

(define-presentation-method present (object (type movie) stream view &key)
  (declare (ignore view))
  (format stream "~a (~a)" (title object) (year object)))

;;;

(defmethod display-movies ((frame movies) stream)
  (dolist (movie (subseq *movies* 0 30))
    (updating-output (stream :unique-id (id movie))
      (present movie 'movie :stream stream)
      (terpri stream))))

(defmethod display-movie ((frame movies) stream)
  (let ((movie (slot-value frame 'current-movie)))
    (when movie
      (with-slots (year title id) movie
        (updating-output (stream :unique-id id)
          (format stream "Title: ~a (~a)" title year)
          (display-views movie stream))))))

(defun display-views (movie stream)
  (let ((views (list-all 'movies:view (where :movie movie))))
    (when views
      (format stream "~%was viewed: ~%")
      (dolist (view views)
        (format stream "~a ~@[in the theater~]"
                (format-date (date view)) (theatre view))))))

;;;

(define-movies-command com-select-movie
    ((movie 'movie :gesture :select))
  (setf (slot-value *application-frame* 'current-movie) movie))

;;;

(defun gui ()
  (run-frame-top-level (make-application-frame 'movies)))
