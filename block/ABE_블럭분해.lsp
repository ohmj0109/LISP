;http://forums.augi.com/
;marko_ribar

(defun BlkSetExplodability (BlockName Explodability / e ed e330 e330d)
;second argument 0=non-Explodability 1=Explodability
   (setq e (tblobjname "block" BlockName)
         ed (entget e)
         e330 (cdr (assoc 330 ed))
         e330d (entget e330)
         e330d (subst (cons 280 Explodability) (assoc 280 e330d) e330d)
   );setq
   (entmod e330d)
   (prin1)
)
(defun c:ABEY ( / ss ssn k ent BlockName)
(setq ss (ssget '((0 . "INSERT"))))
(setq ssn (sslength ss))
(setq k -1)
(repeat ssn
(setq k (1+ k))
(setq ent (ssname ss k))
(setq BlockName (cdr (assoc 2 (entget ent))))
(BlkSetExplodability BlockName 1)
)
)
(defun c:ABEN ( / ss ssn k ent BlockName)
(setq ss (ssget '((0 . "INSERT"))))
(setq ssn (sslength ss))
(setq k -1)
(repeat ssn
(setq k (1+ k))
(setq ent (ssname ss k))
(setq BlockName (cdr (assoc 2 (entget ent))))
(BlkSetExplodability BlockName 0)
)
)
(princ "\n����� ���� �����ϰ��ϴ� ��ɾ� : \"ABEY\" ")
(princ "\n����� ���� ���ϰ��ϴ� ��ɾ� : \"ABEN\" ")
(princ)