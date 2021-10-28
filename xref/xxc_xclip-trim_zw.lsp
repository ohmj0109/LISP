

;;;��Ű��� �ϴܹ�ƴ��� ���� �����Դϴ�.
;;; xclip�� ���� ���Ե� ���·� ������. (explode �� trim�̿�)
;;;ZOOM ���� ��� �߰�
;;;2015.02.26
;;;2015.02.27 vtenable �� ����






(defun c:xxc(/ k xref-10 x-ent pl1 p-pl1 p-ptl entx x-ents x-ents2
               p2 p22 pl2 p-pl2 p-ptl2 x-ents3 x-ent3 i olds chm ix vten)
  (setq vten (getvar "vtenable"))
  (prompt "\n\t xclip�� ���� ���Ե� ���·� ������. (explode �� trim�̿�) ")

  (vl-cmdf "Undo" "Be")
  ;(setvar "vtenable" 2)

  (setq *error* jin4error)
  (setq olds (getvar "Osmode"))
  (setq chm (getvar "Cmdecho"))
  (setvar "Osmode" 0)
  (setvar "Cmdecho" 0)

  (setq k T)
  (defun dxf (id lst)(cdr (assoc id lst)))

  ;; ���� �̸��� �޾Ƶ���.
  (while k    
    (setq x-ent(entsel "\n\t Xref-Block Select ?:"))
    (if (= (dxf 0 (setq x-entl (entget (car x-ent)))) "INSERT")
      (setq k nil b_name (dxf 2 x-entl))
      (prompt "\t ??Select is Not Block?? Select again ")
    )
  )

  (setq xref-10 (dxf 10 x-entl))
;;;  ;; ���� �������� ���� �̸��� ����.
;;;  (vl-cmdf "TEXT" xref-10 300 "" b_name)

  ;; ���� ��輱�� �����Ͽ� ����Ʈ����Ʈ�� �޾Ƶ���.
  (vl-cmdf "XCLIP" x-ent "" "P")
  (setq p-pl1 (entget (setq pl1 (entlast))))
  (setq p-ptmaxmin (pds_GetBoundingBox_ent pl1 'pl1-max 'pl1-min))
  (setq p-ptl (getpolyvtx p-pl1))
  (setq p-ptl (append p-ptl (list (nth 0 p-ptl))))

  (prompt "\n\t block-explode point")
  ;; ���� �����Ͽ� ��ü��ü�� ������.(���Ŀ� erase�� trim�� �ϱ�����)
  (setq entx (entlast))
  (vl-cmdf "explode" x-ent)

  ;; ������ ���߿� ��輱�� ��ģ ���� ������ ������.
  (setq x-ents3 (ssget "F" p-ptl))
  (setq i 0)
  (repeat (sslength x-ents3)
    (setq x-ent3 (ssname x-ents3 i))
    (if (= "INSERT" (dxf 0 (entget x-ent3)))
      (if (and (= (dxf 70 (entget x-ent3)) 0)(= (dxf 71 (entget x-ent3)) 0)) ; �Ӽ����� ������ Ȯ��.
        (vl-cmdf "Explode" x-ent3)
      )
    )
    (setq i (1+ i))
  )

  ;; �������� �����Ͽ� ���� ��ü���� ������.
  (setq x-ents (ssadd) ix 1)
  (while (setq ent (entnext entx))
    (if (/= (dxf 0 (entget ent)) "SEQEND")
      (progn
        (setq x-ents (ssadd ent x-ents))
        (setq entx ent)
      )
;      (setq entx (entnext (dxf -1 (entget ent))))
      (setq entx ent)
    )
    (setq ix (1+ ix))
  )

  (prompt "\n\t select outside entty")
  ;; ��輱�� �ٱ��� �����ϴ� ��ü�� �����Ͽ� ����.
  (setq x-ents2 (ssget "CP" p-ptl))
  (setq i 0)
  (repeat (sslength x-ents2)
    (ssdel (ssname x-ents2 i) x-ents)
    (setq i (1+ i))
  )
  (vl-cmdf "erase" x-ents "")

  (prompt "\n\t first trim")
  ;; ��輱�� �ٱ��� �Ѱ��� �����ؼ� ��輱�� �ɼ��ϰ� ����Ʈ����Ʈ�� �޾�
  ;; Ʈ���� ��ü�� ������.
  (setq p2  (polar pl1-max (angle pl1-min pl1-max)(* (distance pl1-max pl1-min) 0.01)))
  (setq p22 (polar pl1-min (angle pl1-max pl1-min)(* (distance pl1-max pl1-min) 0.01)))
  ;(setq p2 (getpoint "\n\t Box�� �ٱ��� �������� �����Ͻÿ�. ?:"))
  (vl-cmdf "offset" "T" pl1 p2 "")
  (vl-cmdf "_.zoom" p2 p22)
  (setq p-pl2 (entget (setq pl2 (entlast))))
  (setq p-ptl2 (getpolyvtx p-pl2))
  (setq p-ptl2 (append p-ptl2 (list (nth 0 p-ptl2))))
  (vl-cmdf "erase" pl2 "") ; �ɼµ� ��輱 ����
  (repeat 5
    (vl-cmdf "Trim" pl1 "" "F")
    (mapcar 'vl-cmdf p-ptl2)
    (vl-cmdf "" "" )
  )

  (setvar "Osmode" olds)
  (setvar "Cmdecho" chm)
  (setvar "vtenable" vten)
  (command "zoom" "p")
  (vl-cmdf "Undo" "End")
)

(defun GetPolyVtx(EntList)
  (setq VtxList '())
  (foreach x EntList
   (if (= (car x) 10)
    (setq VtxList (append VtxList (list (cdr x))))
   )
  )
VtxList
)

(defun pds_GetBoundingBox_ent (ent pt1 pt2 / ent0 ptlst b-ent ps pe ptl pt max-x max-y min-x min-y maxp minp) ; sub
  (setq ptlst nil)
  (setq ent0 (dxf 0 (setq entl (entget ent))))
  (cond
    ((= ent0 "LINE")      (setq ps (dxf 10 entl) pe (dxf 11 entl) ptlst (append ptlst (list ps pe))))
    ((= ent0 "LWPOLYLINE")(setq ptl (GetpolyVtx entl) ptlst (append ptlst ptl)))
    ((= ent0 "POINT")     (setq pt (dxf 10 entl) ptlst (append ptlst (list pt))))
    (T nil)
  )
  (setq max-x (apply 'max (mapcar '(lambda (x) (car x)) ptlst))) ; x��ǥ��ū��
  (setq max-y (apply 'max (mapcar '(lambda (x) (cadr x)) ptlst))) ; y��ǥ��ū��
  (setq min-x (apply 'min (mapcar '(lambda (x) (car x)) ptlst))) ; x��ǥ��������
  (setq min-y (apply 'min (mapcar '(lambda (x) (cadr x)) ptlst))) ; x��ǥ��������

  (setq maxp (list max-x max-y) minp (list min-x min-y))
  (set (eval 'pt1) maxp)
  (set (eval 'pt2) minp)

 
)

;;; END OF XP5
