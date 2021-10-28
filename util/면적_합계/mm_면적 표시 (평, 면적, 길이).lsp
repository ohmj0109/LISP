;---------------------------------------------------------------------------;
;                                                                           ;
;                                                                           ;
;                                                                           ;
;                                                                           ;
; ���ͳ� �̰�����.... �������ּ���...                                       ;
; ���۱� ������ �ȴٸ� �����ϰڽ��ϴ�. http://szpl.tistory.com/             ;
; Zebra Pattern Lemon                                                       ;
;                                                                           ;
; ���̾� ���� ���� ��ɾ� ���� : http://szpl.tistory.com/11                 ;
;                                                                           ;
;                                                                           ;
;                                                                           ;
;                                                                           ;
;---------------------------------------------------------------------------;
(defun c:mm ( / doc space ss index obj mi mx minpt maxpt inspt area txtobj )
 (setvar "cmdecho" 0)
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (cond
    ((= (vla-get-activespace doc) 1) (setq space (vla-get-modelspace doc)))
    ((= (vla-get-activespace doc) 0) (setq space (vla-get-paperspace doc)))
    )
  (if (setq ss (ssget (list (cons 0 "CIRCLE,ARC,*POLYLINE,LINE,ELLIPSE,SPLINE"))))
    (if (or (setq ts (getreal (strcat "\n�ؽ�Ʈ ���� �Է� <" (vl-princ-to-string (getvar "textsize")) ">:"))) (setq ts (getvar "textsize")))
      (progn
  (setvar "textsize" ts)
 (setq index 0)
 (repeat (sslength ss)
   (setq obj (vlax-ename->vla-object (ssname ss index)))
   (vla-getboundingbox obj 'mi 'mx)
   (setq minpt (vlax-safearray->list mi) maxpt (vlax-safearray->list mx))
   (setq inspt (polar minpt (angle minpt maxpt) (/ (distance minpt maxpt) 2)))
   (setq inspt (list (car inspt) (+ (cadr inspt) (* ts 2))))
   (setq area (vla-get-area obj) len (vlax-curve-getdistatparam obj (vlax-curve-getendparam obj)))
   (mapcar '(lambda (a b)
       (setq p (vlax-3d-point inspt))
       (setq txtobj (vla-addtext space (strcat a b) p ts))
       (vla-put-alignment txtobj 4)
       (vla-put-textalignmentpoint txtobj p)
       (setq inspt (polar inspt (/ (* 270 pi) 180) (* ts 2)))
       )
              '("�� : " "����(��)  : " "����(mm) : " ) (list (rtos (/ area 3305796.) 2 2) (rtos (/ area 1000000.) 2 3) (rtos len 2 2))
    )
   (setq index (1+ index))
   )
 (command "chprop" (ssget "x" '((0 . "TEXT") (1 . "��*"))) "" "c" "7" "")
 )
      )
    )
  (princ)
  )
(vl-load-com)
(prompt "\n[ AAA ]")
(princ)