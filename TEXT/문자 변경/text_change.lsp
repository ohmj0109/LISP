(defun C:ok ()
   (setvar "cmdecho" 0)
   (setvar "blipmode" 0)
       (prompt "\n** �ʿ乮�ڸ� �����ϼ��� **")
       (setq new-text (entsel)
             text-list (entget (car new-text))
             new-string (cdr (assoc 1 text-list))
             );;end of setq
       (prompt "\n** ���湮�ڸ� �����ϼ��� **")
       (setq sel (ssget)) 
       (setq sl (sslength sel)) 
       (setq cn 0)
       (while (< cn sl)
         (if (= "TEXT" (cdr (assoc 0 (entget (ssname sel cn)))))
            (progn
            (setq ef1 (ssname sel cn)) 
            (setq el1 (entget ef1))
            (setq el2 (cdr (assoc 1 el1))) 
            (setq el3 (strcat new-string))
            (setq el1 (subst (cons 1 el3) (assoc 1 el1) el1))
            (entmod el1)
            (setq cn (+ 1 cn))  
            ); progn  
            (setq cn (+ 1 cn)) 
            );if 
            );while
            (prin1)    
);defun
