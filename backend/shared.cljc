(ns gitcode.viewer.workspace
  #?(:clj  (:require [clojure.string :as str])
     :cljs (:require [clojure.string :as str])))

(def extension-aliases
  {"cts" "typescript"
   "ets" "typescript"
   "mts" "typescript"
   "json5" "json"
   "jsonc" "json"
   "liquid" "html"})

(def sample-workspaces
  [{:id "workspace-core"
    :name "CodeReader"
    :owner "ada"
    :branch "main"
    :last-sync "2026-03-09T09:04:00Z"
    :favorite? true}
   {:id "mobile-ui"
    :name "WorkspaceMobile"
    :owner "lin"
    :branch "feature/mobile-title"
    :last-sync "2026-03-09T08:51:00Z"
    :favorite? true}
   {:id "syntax-lab"
    :name "SyntaxFixtures"
    :owner "mo"
    :branch "refresh/samples"
    :last-sync "2026-03-09T08:32:00Z"
    :favorite? false}
   {:id "docs-site"
    :name "DocsSite"
    :owner "yan"
    :branch "content/runbook"
    :last-sync "2026-03-08T21:15:00Z"
    :favorite? false}])

(defn normalize-extension [ext]
  (let [clean (-> ext str str/lower-case (str/replace #"^\." ""))]
    (get extension-aliases clean clean)))

(defn workspace-search-text [{:keys [name owner branch]}]
  (str/lower-case (str/join " " [name owner branch])))

(defn matches-query? [workspace query]
  (let [needle (str/trim (str/lower-case (or query "")))]
    (or (str/blank? needle)
        (str/includes? (workspace-search-text workspace) needle))))

(defn sort-workspaces [workspaces]
  (sort-by (juxt (complement :favorite?) :name) workspaces))

(defn favorite-workspaces [workspaces]
  (filter :favorite? workspaces))

(defn workspace-summary [{:keys [name owner branch favorite?]}]
  {:title name
   :subtitle (str owner " / " branch)
   :badge (when favorite? "Pinned")})

(defn summarize-recent [workspaces]
  (->> workspaces
       sort-workspaces
       (map workspace-summary)
       vec))

(defn grouped-by-owner [workspaces]
  (reduce
    (fn [acc {:keys [owner] :as workspace}]
      (update acc owner (fnil conj []) workspace))
    {}
    workspaces))

(defn resolve-sample-language [filename]
  (let [parts (str/split filename #"\.")
        ext (last parts)]
    (normalize-extension ext)))

(defn visible-workspaces [query]
  (->> sample-workspaces
       (filter #(matches-query? % query))
       sort-workspaces
       vec))

(comment
  (visible-workspaces "mobile")
  (favorite-workspaces sample-workspaces)
  (resolve-sample-language "Sample_typescript_ets.ets")
  (grouped-by-owner sample-workspaces))