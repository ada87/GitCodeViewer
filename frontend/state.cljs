(ns gitcode.viewer.workspace-page
  (:require [clojure.string :as str]
            [reagent.core :as r]))

(defonce *state
  (r/atom
    {:query ""
     :selected-id "workspace-core"
     :workspaces
     [{:id "workspace-core" :name "CodeReader" :branch "main" :owner "ada" :updated "3 min ago" :status :healthy}
      {:id "mobile-ui" :name "WorkspaceMobile" :branch "feature/mobile-title" :owner "lin" :updated "17 min ago" :status :review}
      {:id "syntax-lab" :name "SyntaxFixtures" :branch "refresh/samples" :owner "mo" :updated "42 min ago" :status :healthy}
      {:id "docs-site" :name "DocsSite" :branch "content/runbook" :owner "yan" :updated "yesterday" :status :healthy}
      {:id "android-shell" :name "AndroidShell" :branch "fix/safe-area" :owner "qi" :updated "2 days ago" :status :pending}]}))

(defn status-label [status]
  (case status
    :healthy "Healthy"
    :review "Needs review"
    :pending "Pending"
    "Unknown"))

(defn visible-workspaces [{:keys [query workspaces]}]
  (let [needle (-> query str/lower-case str/trim)]
    (filter
      (fn [{:keys [name branch owner]}]
        (or (str/blank? needle)
            (str/includes? (str/lower-case name) needle)
            (str/includes? (str/lower-case branch) needle)
            (str/includes? (str/lower-case owner) needle)))
      workspaces)))

(defn select-workspace! [workspace-id]
  (swap! *state assoc :selected-id workspace-id))

(defn search-box []
  [:input
   {:type "search"
    :value (:query @*state)
    :placeholder "Filter by repo, branch, or owner"
    :on-change #(swap! *state assoc :query (.. % -target -value))}])

(defn workspace-row [{:keys [id name branch owner updated status]}]
  [:button.workspace-row
   {:class (when (= id (:selected-id @*state)) "workspace-row--selected")
    :on-click #(select-workspace! id)}
   [:div.workspace-row__main
    [:strong name]
    [:div.workspace-row__meta (str owner " / " branch)]]
   [:div.workspace-row__aside
    [:span.workspace-row__updated updated]
    [:span.workspace-row__status (status-label status)]]])

(defn selected-workspace []
  (let [{:keys [selected-id workspaces]} @*state
        current (first (filter #(= (:id %) selected-id) workspaces))]
    [:section.workspace-panel
     [:h2 (:name current)]
     [:p (str "Branch: " (:branch current))]
     [:p (str "Owner: " (:owner current))]
     [:p (str "Last sync: " (:updated current))]
     [:p "The mobile header title should remain centered on phones while still reading as interactive."]]))

(defn workspace-page []
  (let [state @*state]
    [:main.workspace-page
     [:header.workspace-page__header
      [:h1 "Recent Workspaces"]
      [search-box]]
     [:section.workspace-page__layout
      [:div.workspace-page__list
       (for [workspace (visible-workspaces state)]
         ^{:key (:id workspace)} [workspace-row workspace])]
      [selected-workspace]]]))

(defn mount! []
  (r/render [workspace-page] (.getElementById js/document "app")))

(defn ^:export init []
  (mount!))