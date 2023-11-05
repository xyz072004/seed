(local js (require :js))

(local seed {:_VERSION "dev-1"})

(local Ref {})
(tset Ref :__index Ref)

(fn Ref.get [self]
  self.value)

(fn Ref.set [self value]
  (let [old-value self.value]
    (tset self :value value)
    (each [_ handler (ipairs self.listeners)]
      (handler self.value old-value))))

(fn Ref.transform [self transform]
  (self:set (transform (self:get))))

(fn Ref.subscribe [self handler]
  (table.insert self.listeners handler))

(fn seed.ref [value]
  (let [self {: value
              :listeners []}]
    (setmetatable self Ref)))

(lambda create-node [tag attr children]
  (let [element (js.global.document:createElement tag)]
    (each [key value (pairs attr)]
      (match key
        :# (value:subscribe (fn []
                              (tset value :listeners (length value.listeners) nil)
                              (element:replaceWith (create-node tag attr children))))

        (where reactive (= (reactive:sub (length reactive)) :#))
        (do
          (element:setAttribute (reactive:sub 1 (- (length reactive) 1)) (value:get))
          (value:subscribe (element:setAttribute (reactive:sub 1 (- (length reactive) 1)) (value:get))))

        _ (tset element key value)))

    (each [_ child (ipairs children)]
      (element:appendChild (match (type child)
                             :function (js.global.document:createTextNode (child))
                             :string (js.global.document:createTextNode child)
                             _ child)))
    element))

(lambda create-element [self tag]
  (fn [...]
    (match [...]
      (where [attr & children] (= (type attr) :table)) (create-node tag attr children)
      (where [attr] (= (type attr) :table)) (create-node tag attr [])
      _ (create-node tag {} [...]))))

(setmetatable seed {:__index create-element})
