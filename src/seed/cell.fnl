;; Este archivo es parte de seed.
;; Para todos los efectos y propósitos, esta obra debe considerarse de Dominio Público.

(local cell {:_VERSION "0.1.0"})

(local dependencies {})

(local Cell {:__type :cell})
(tset Cell :__index Cell)

(lambda Cell.__call [self ?v]
  (when ?v
    (tset self :value ?v)
    (self:notify))
  (. self :value))

(fn Cell.notify [self]
  (if (?. dependencies self)
      (each [dependent _ (pairs (. dependencies self))]
        (dependent:update)
        (self.notify dependent))))

(fn Cell.update [self]
  (case self
    {: transform : source} (tset self :value (transform (source)))
    {: sources} (let [values* (icollect [_ src (ipairs sources)] (src))]
                  (tset self :value values*))))

(fn Cell.map [self f]
  (let [result (setmetatable {:source self
                              :transform f}
                             Cell)]
    (when (not (?. dependencies self))
      (tset dependencies self {}))
    (tset dependencies self result true)
    (result:update)
    result))

(lambda cell.merge [& cells]
  (let [result (setmetatable {:sources cells} Cell)]
    (each [_ src (ipairs cells)]
      (when (not (?. dependencies src))
        (tset dependencies src {}))
      (tset dependencies src result true))
    (result:update)
    result))

(setmetatable cell
              {:__call (fn [self value]
                        (setmetatable {: value}
                                      Cell))})