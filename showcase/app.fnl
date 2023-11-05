(local js (require :js))
(local {: ref : p : div : button} (require :src.seed))

(fn Counter []
  (let [count (ref 0)]
    (div  
      (p {:id# count :# count} #(tostring (count:get)))
      (button {:onclick (fn [] (count:transform #(+ $ 1)))} "+1")
      (button {:onclick (fn [] (count:transform #(- $ 1)))} "-1"))))

(js.global.document.body:appendChild (Counter))
