; Clojure sample for CodeMirror language testing
; Target: keep file length between 80 and 200 lines

(ns gitcodeviewer.demo.clojure
  (:require [clojure.string :as str]
            [clojure.set :as set]))

(def repos
  [{:id 1 :name "code-reader" :language "clojure" :stars 1200 :updated "2026-03-01"}
   {:id 2 :name "gitcode-viewer" :language "typescript" :stars 980 :updated "2026-03-03"}
   {:id 3 :name "mobile-kit" :language "kotlin" :stars 640 :updated "2026-02-27"}
   {:id 4 :name "cli-tools" :language "clojure" :stars 410 :updated "2026-02-20"}])

(defn parse-int [v]
  (cond
    (integer? v) v
    (string? v) (Integer/parseInt v)
    :else 0))

(defn normalize-repo [repo]
  (-> repo
      (update :name str/lower-case)
      (update :stars parse-int)
      (update :language #(or % "unknown"))))

(defn stale? [repo]
  (let [threshold "2026-02-28"]
    (neg? (compare (:updated repo) threshold))))

(defn by-language [items]
  (reduce (fn [acc repo]
            (update acc (:language repo) (fnil conj []) repo))
          {}
          items))

(defn language-stats [items]
  (->> items
       (map normalize-repo)
       by-language
       (map (fn [[language xs]]
              {:language language
               :count (count xs)
               :stars (reduce + (map :stars xs))
               :stale (count (filter stale? xs))}))
       (sort-by (juxt (comp - :stars) (comp - :count)))))

(defn top-repo [items]
  (first (sort-by (comp - :stars) items)))

(defn search-repos [items q]
  (let [q* (str/lower-case (str/trim q))]
    (filter #(or (str/includes? (:name %) q*)
                 (str/includes? (:language %) q*))
            items)))

(defn attach-score [repo]
  (let [score (+ (* 0.7 (:stars repo))
                 (* 3 (count (:name repo)))
                 (if (stale? repo) -30 25))]
    (assoc repo :score (long score))))

(defn pipeline [items q]
  (->> items
       (map normalize-repo)
       (search-repos q)
       (map attach-score)
       (sort-by (comp - :score))))

(defn print-stats [items]
  (println "=== Clojure Stats ===")
  (doseq [row (language-stats items)]
    (println (format "%s count=%d stars=%d stale=%d"
                     (:language row) (:count row) (:stars row) (:stale row)))))

(defn print-results [items]
  (println "=== Search Results ===")
  (doseq [repo items]
    (println (format "#%d %s (%s) stars=%d score=%d"
                     (:id repo) (:name repo) (:language repo) (:stars repo) (:score repo)))))

(defn sample-transform-a [x]
  {:step "a" :input x :output (+ x 10) :ok (> (+ x 10) x)})

(defn sample-transform-b [x]
  {:step "b" :input x :output (* x 2) :ok (>= (* x 2) x)})

(defn sample-transform-c [x]
  {:step "c" :input x :output (- (* x 3) 1) :ok true})

(defn sample-transform-d [x]
  {:step "d" :input x :output (quot (+ x 7) 2) :ok true})

(defn sample-transform-e [x]
  {:step "e" :input x :output (mod (+ x 17) 5) :ok true})

(defn -main [& args]
  (let [q (or (first args) "code")
        normalized (map normalize-repo repos)
        result (pipeline repos q)
        best (top-repo normalized)]
    (print-stats normalized)
    (println "Top repo:" (:name best) "stars=" (:stars best))
    (print-results result)
    (println "Rows:" (count result))))

(comment
  (-main "clojure")
  (sample-transform-a 5)
  (sample-transform-b 5)
  (sample-transform-c 5)
  (sample-transform-d 5)
  (sample-transform-e 5))

