;============================================================
;  단열재 그리기 (96cho_i)
;------------------------------------------------------------
(defun c:s1(/ myerror os bl cl pt1 pt2 pt3 pt4 thi angX angY n di
              b1 b2 b3 b4 p1 p2 p3 p4 p5 p6 p7 p8 f1 f2)
   (command "undo" "group")
   (setvar "cmdecho" 0)
   (setq os (getvar "osmode"))
   (setq bl (getvar "blipmode"))
   (setq cl (getvar "clayer"))
;----------------- Internal error handler -------------------
 (defun myerror(S)
  (if (/= s "Function cancelled")
      (princ (strcat "\nError:" s))
  )
  (setq *error* olderr)
  (setvar "osmode" os)
  (setvar "clayer" cl)
;  (setvar "blipmode" bl)
  (princ)
 )
 (setq olderr *error* *error* myerror)
;------------------------------------------------------------
;   (setvar "blipmode" 1) 
   (setvar "osmode" 33)
   (setq pt1 (getpoint "\nFirst point... : "))
   (setvar "osmode" 128)
   (setvar "orthomode" 1)
   (setq pt2 (getpoint pt1 "\nThickness point... : "))
   (setq th (distance pt1 pt2))
   (setvar "osmode" 1)
   (setq pt3 (getpoint pt1 "\nSecond point... : "))
   (setvar "blipmode" 0)(setvar "osmode" 0)
;   (if (= th nil) (setq th 50))
;   (setq thi (getdist (strcat "\nThickness<"(rtos th 2 0)">:" "")))
;   (if (= thi nil) (setq thi th))
   (setq thi th)
   (setq sc (/ thi 50))
   (setq sc2 (/ thi 4)); pedit간격
   (setq angX (angle pt1 pt3) angY (angle pt1 pt2))
   (setq di (distance pt1 pt3))
   (setq n (/ di (* sc 25)) )
;   (laset "etc")
   (setq b1 (polar pt1 angY (* sc 4.32))
         b2 (polar pt1 angY (* sc 13.55))
         b3 (polar pt1 angY (* sc 36.45))
         b4 (polar pt1 angY (* sc 50.00))) 
   (setq p1 (polar b1 angX (* sc 8.23))
         p2 (polar b2 angX (* sc 9.35))
         p3 (polar b3 angX (* sc 3.15))
         p4 (polar b4 angX (* sc 12.50))
         p5 (polar b3 angX (* sc 21.85))
         p6 (polar b2 angX (* sc 15.65))
         p7 (polar b1 angX (* sc 16.77))
         p8 (polar pt1 angX (* sc 25.00)))
   (command "layer" "m" "wall2" "c" "1" "" "s" "wall2" "")
   (command "pline" pt1 "a" "s" p1  p2 "l" p3 "a" "s" p4
                    p5 "l" p6 "a" "s" p7 p8 "")
   (while (>= n 1)
;   (setq pt1 p8) 
   (setq p8 (polar pt1 angX (* sc 25.00)))
;   (setq p9 (/  4))
   (command "copy" "l" "" pt1 p8)
   (setq n (- n 1))
);while end
   (setq angA (angle pt3 pt1))
   (setq f1 (polar pt1 angY sc2))
   (setq f2 (polar pt3 angY sc2))
   (setq f3 (polar f1 angX sc2))
   (setq f4 (polar f2 angA sc2))
   (setvar "osmode" 0)
   (command "pedit" "l" "j" "f" f3 f4 "" "" "")
;  (command "pedit" "l" "j" "w" pt2 pt3 "" "" "")

   (setvar "clayer" cl)
   (setvar "blipmode" bl)
     (SETVAR "OSMODE" 2199)
   (command "undo" "en")
   (princ "\nThickness : ") (princ thi) (princ "mm")
   (prin1)
)
