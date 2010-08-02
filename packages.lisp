;;; -*- Mode: Lisp -*-

(defpackage #:tracking
  (:use #:cl)
  (:export

   #:person
   #:male
   #:female
   #:movie
   #:movies
   #:short-movie
   #:feature-movie
   #:unwatched-movie
   #:theatre
   #:view

   #:title
   #:date
   #:theatre
   #:animated-p
   #:duration
   #:documentary-p
   #:directors
   #:writers
   #:producers
   #:cast
   #:countries
   #:year
   #:imdb-id
   #:alternate-titles
   #:name
   #:died
   #:born
   #:imdb-id

   #:format-date
   #:month
   #:sort-hash-table-to-alist
   #:identifiable
   #:imdb-url
   #:last-views
   #:print-movies

   #:movies-by-decade
   #:views-per-month
   #:top-years
   #:top-persons
   #:top-countries
   #:with-tracking
   #:number-of-movies-by-decade
   #:book
   #:english-title
   #:authors
   #:isbn
   #:pages
   #:read-p
   #:book-format
   #:novel
   #:novella
   #:essay
   #:play
   #:short-story
   #:short-story-collection
   #:poem
   #:reading
   #:from-page
   #:to-page
   #:tv-series
   #:year-start
   #:year-end
   #:creators
   #:episodes
   #:episode
   #:original-air-date
   #:season
   #:episode-number
   #:activity
   #:distance
   #:average-speed
   #:max-speed
   #:average-heart-rate
   #:max-heart-rate
   #:elevation
   #:bicycle-ride
   #:run
   #:object
   #:actions
   #:actions
   #:action
   #:action-on-object))

(defpackage #:iso-3166-1
  (:use #:cl)
  (:export
   #:code-country
   #:country-code))

(defpackage #:imdb
  (:use #:cl)
  (:shadow #:search)
  (:export #:search
           #:parse-page))

(defpackage #:ascii-graph
  (:use #:cl)
  (:export #:bar-graph))

(defpackage #:freebase
  (:use #:cl))

(defpackage #:http
  (:use #:cl)
  (:export #:request
           #:*stream*))
