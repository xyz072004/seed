;; Este archivo es parte de seed.
;; Para todos los efectos y propósitos, esta obra debe considerarse de Dominio Público.

(local {: view} (require :fennel))

(local element {:_VERSION "0.1.0"})

(local Element {:__type :element})
(tset Element :__index Element)

;; TODO: esto es una aberración. una escupitajo en la cara a la raza humana.
;; necesito dividir el meta método en varias (chance una nada más) funciones!!1!!1

(setmetatable element {:__call (lambda [self ...]
                                 (case [...]
                                   (where [tag props & ?children]
                                          (and (= (type props) :table)
                                               (not (getmetatable props))))
                                   (setmetatable {: tag
                                                  : props
                                                  :children (icollect
                                                              [_ child (ipairs ?children)]
                                                              (if (and (= (type child) :table)
                                                                       (getmetatable child)
                                                    (= (. (getmetatable child) :__type) :element))
                                               child
                                               (setmetatable {:tag :text
                                                              :content
                                                              (tostring child)}
                                                             Element))
                                                              )
                                                  }
                                                 Element)

                                   [tag & ?children]
                                   (let [children
                                         (icollect
                                           [_ child (ipairs ?children)]
                                           (if (and (= (type child) :table)
                                                    (getmetatable child)
                                                    (= (. (getmetatable child) :__type) :element))
                                               child
                                               (setmetatable {:tag :text
                                                              :content
                                                              (tostring child)}
                                                             Element)))]

                                    (setmetatable {: tag
                                                   :props {}
                                                   : children} Element))

                                   [tag] (do (print :y) (setmetatable {: tag
                                                        :props {}
                                                        :children []}
                                                       Element))

                                   _ (setmetatable _ Element)))

                       :__index (fn [self tag]
                                  (fn [...]
                                    (element tag ...)))})