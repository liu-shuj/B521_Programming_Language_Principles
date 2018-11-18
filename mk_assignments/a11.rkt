#lang racket
(require "mk.rkt")

(defrel (apply-Go G e t)
  (fresh (a G^)
         (== `(,a . ,G^) G)
         (fresh (aa da)
                (== `(,aa . ,da) a)
                (conde
                 ((== aa e) (== da t))
                 ((=/= aa e) (apply-Go G^ e t))))))

(defrel (!- G e t)
  (conde
   ((numbero e) (== 'Nat t))
   ((== t 'Bool)
    (conde
     ((== #t e))
     ((== #f e))))
   ((fresh (rand)
           (!- G rand `(,t -> ,t))
           (== `(fix ,rand) e)))
   ((fresh (b)
           (== 'Bool t)
           (!- G b 'Bool)
           (== `(not ,b) e)))
   ((fresh (n)
           (== 'Bool t)
           (!- G n 'Nat)
           (== `(zero? ,n) e)))
   ((fresh (n)
           (== 'Nat t)
           (!- G n 'Nat)
           (== `(sub1 ,n) e)))
   ((fresh (m1 m2)
           (== 'Nat t)
           (!- G m1 'Nat)
           (!- G m2 'Nat)
           (== `(* ,m1 ,m2) e)))
   ((fresh (ne1 ne2)
           (== 'Nat t)
           (!- G ne1 'Nat)
           (!- G ne2 'Nat)
           (== `(+ ,ne1 ,ne2) e)))
   ((fresh (a d ta td)
           (== `(pairof ,ta ,td) t)
           (!- G a ta)
           (!- G d td)
           (== `(cons ,a ,d) e)))
   ((fresh (p td)           
           (!- G p `(pairof ,t ,td))
           (== `(car ,p) e)))
   ((fresh (p ta)           
           (!- G p `(pairof ,ta ,t))
           (== `(cdr ,p) e)))
   ((fresh (teste anse elsee)
           (!- G teste 'Bool)
           (!- G anse t)
           (!- G elsee t)
           (== `(if ,teste ,anse ,elsee) e)))
   ((symbolo e) (apply-Go G e t))
   ((fresh (x b)
           (symbolo x)
           (fresh (tx tb)          
                  (== `(,tx -> ,tb) t)
                  (!- `((,x . ,tx) . ,G) b tb))
           (== `(lambda (,x) ,b) e)))
   ((fresh (e1 arg)
           (fresh (targ)
                  (!- G e1 `(,targ -> ,t))
                  (!- G arg targ))
           (== `(,e1 ,arg) e)))))