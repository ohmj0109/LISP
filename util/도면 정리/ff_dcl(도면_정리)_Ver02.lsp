;;=====================================================================
;  ���������ϱ�(2007.8.26 �ָ����)
;  ->Audit, Draworder, Purge,  Point<node> Delete,
;    Layer Filters Delete. Ghost delete.
;  ->ghost ��������/���鿭�� �ִ°� ��λ���(2007.12.12)
;
;
; 3.16�� ���� �ۼ�(2007.12)
;
;
;  acad 2011 ��밡��
;  �߰�����(2011.09.25 �Ϸ�) 
;  �ּ������ϱ�(�߰�)
;  �ָ���ڷκ�����-HATCHTOBACK ������� ����
;  dcl lisp �� ����
;
;
;  �߰�����(2014.10.20 �Ϸ�) 
;  DGN ���� ����
;
;  ���ô� 2013.01.22    
;  �ߺ��� PLine, Vertex Line, Block, Text, Text �޺κ� ���� ���� �߰�
;
;
;  �ʷϺ��� 2014.06.30
;  DNG���� Audit & purge �߰�
; 
;
;  ���溹 - �ߺ� text �����ϱ�
;
;------- file filtering -----------------------------------------------
(defun c:ff(/ tg1 tg2 tg3 tg4 tg5 tg6 tg7 tg8 tg9 tg10 tg11 tg12 tg13 tg14 ky fname) ; �ӽ����� fname �����


	;-------------------------------------------------------------------------
	; DCLȭ���� �ӽ÷� �����
	;
	;
	; DCL ���� & Lisp & Sld
	; �ູ���Ϸ�� ����
	; (setq fname (vl-filename-mktemp "dcl.dcl")) 
	; (setq fn (open fname "w")) 
	; (write-line "dcl����" fn)
	; (close fn)
	;-------------------------------------------------------------------------

	(defun subDclFile (/ fname fn)
	(setq fname (vl-filename-mktemp "dcl.dcl")) 
	 (setq fn (open fname "w")) 
	 (write-line 
	   "file_filter : dialog { label=\"���� ���� �ϱ�(Cad Files Diet)\";
	   : boxed_column {label = \"������ ��� ����\";
	        : column {
	            : toggle {label=\"  1. ���鰨��<Audit> �ϱ�\"; key=\"tog1\";}
 	            : toggle {label=\"  2. �ָ��� �ڷ�<Hatchtoback> ������\"; key=\"tog2\";}
	            : toggle {label=\"  3. ����<Purge> �ϱ�\"; key=\"tog3\";}
	            : toggle {label=\"  4. �ּ�<Scale List> ���� �ϱ�\"; key=\"tog4\";}
	            : toggle {label=\"  5. ����Ʈ<Node> ����\"; key=\"tog5\";}
	            : toggle {label=\"  6. ���̾� ����<Filter> ����\"; key=\"tog6\";}
	            : toggle {label=\"  7. DGN<Audit & purge>\"; key=\"tog7\";}
	            : toggle {label=\"  8. �ߺ��� PLine ����\"; key=\"tog8\";}
	            : toggle {label=\"  9. �ߺ��� Vertex Line ����\"; key=\"tog9\";}
	            : toggle {label=\" 10. �ߺ��� Hetch ����\"; key=\"tog10\";}
	            : toggle {label=\" 11. �ߺ��� Text ����\"; key=\"tog11\";}
	            : toggle {label=\" 12. Text �޺κ� Space ����\"; key=\"tog12\";}
	            : toggle {label=\" 13. ������ ����<Text>, ���̰� 0��<Line> ���ɰ�ü ����\"; key=\"tog13\";}
	            : toggle {label=\" ��� �����ϱ� / ��� ����ϱ�\"; key=\"tog14\";}
	      }
	   }
	   ok_cancel;
	}
	" fn)
	 (close fn)
         fname
	)

	;-------------------------------------------------------------------------
	; DCL �����ƾ
	;-------------------------------------------------------------------------
	(defun @ff_select(tg14)
	   (cond
	      ((= tg14 "0")(setq tg1 "0" tg2 "0" tg3 "0" tg4 "0" tg5 "0" tg6 "0" tg7 "0" tg8 "0" tg9 "0" tg10 "0" tg11 "0" tg12 "0" tg13 "0" tg14 "0"))
	      ((= tg14 "1")(setq tg1 "1" tg2 "1" tg3 "1" tg4 "1" tg5 "1" tg6 "1" tg7 "1" tg8 "1" tg9 "1" tg10 "1" tg11 "1" tg12 "1" tg13 "1" tg14 "1"))
	   )
	   (set_tile "tog1" tg1)(set_tile "tog2" tg2)
	   (set_tile "tog3" tg3)(set_tile "tog4" tg4)
	   (set_tile "tog5" tg5)(set_tile "tog6" tg6)
	   (set_tile "tog7" tg7)(set_tile "tog8" tg8)
	   (set_tile "tog9" tg9)(set_tile "tog10" tg10)
	   (set_tile "tog11" tg11)(set_tile "tog12" tg12)
	   (set_tile "tog13" tg13)(set_tile "tog14" tg14)
	)




	;-------------------------------------------------------------------------
	; �������� ���� ����Ʈ
	;-------------------------------------------------------------------------
	(defun GetPolyVtx(EntList)
	   (setq VtxList '())
	   (foreach x EntList
	      (if (= (car x) 10) (setq VtxList (append VtxList (list (cdr x)))) )
	   )
	VtxList)


	;-------------------------------------------------------------------------
	; 5. ����Ʈ ����
	;-------------------------------------------------------------------------
	(defun @pointdelete(/ ss)
	   (setq ss (ssget "x" (list (cons 0 "point"))))
	   (if ss (progn (command "erase" ss "") (princ "\n->Point<node> ")
	         (princ (sslength ss)) (princ "��") (princ " �����Ͽ����ϴ�.") ))
	(prin1))



	;-------------------------------------------------------------------------
	; 6. ���̾� ���� �����ϱ�
	;-------------------------------------------------------------------------
	(defun @layerfilterdelete(/ objXDict)
	   (setq strKeepWC "")
	   (vl-load-com)
	   (vl-catch-all-apply
	      (function
	         (lambda ()
	            (setq objXDict (vla-GetExtensionDictionary
	                  (vla-get-Layers (vla-get-ActiveDocument (vlax-get-acad-object)))))))
	   )
	   (cond (objXDict
	        (or
	         (rrbI:DeleteAllXRecs objXDict "ACAD_LAYERFILTERS" strKeepWC)
	         (rrbI:DeleteAllXRecs objXDict "AcLyDictionary" strKeepWC))))
	(princ))
	(defun rrbI:DeleteAllXRecs  (objXDict dictName strKeepWC / objDict i)
	   (vl-catch-all-apply
		   (function
	      (lambda ()
	         (setq objDict (vla-Item objXDict dictName))
	         (vlax-for objXRec  objDict
	            (cond ((not (and strKeepWC (wcmatch (vla-Get-Name objXRec) strKeepWC)))
	               (setq i (1+ (cond (i)
	                              (0))))
	               (vla-Delete objXRec)))))))
		   (cond (i (princ (strcat "\n" (itoa i) " filters deleted."))))
	)
	
		

	;-------------------------------------------------------------------------
	; 7. DGN Audit & purge
	;-------------------------------------------------------------------------


	(defun DGN (/)
	  (if (dictremove (namedobjdict) "acad_dgnlinestylecomp")
	    (progn
      (princ
	 "\nClean DGN-rubbish complete.  ASAP, Audit & purge is recommended !!! ."
	      )
	    )
	    (princ
	      "\nacad DGNlinestylecomp not found."
	    )
	  )
	  (princ)
	)



	;-------------------------------------------------------------------------
	; 8. �ߺ��� PLine ����
	;-------------------------------------------------------------------------

	(defun pdd (/ a i al tt ke xy xy_list w_list k j)
	(command "cmdecho" 0)
	(command "undo" "g")
	(setq a (ssget "all" '((0 . "LWPOLYLINE"))))
	(if (null a)
	(setq a (ssget "x" '((0 . "LWPOLYLINE"))))
	)
	(if (null a) (exit))
	(setq al (sslength a)
		i 0
		j 0
		tt 0
		)

	(while (> al i)
		(setq en (ssname a i)
			ent (entget en)
			la (cdr (assoc 8 ent))
			i (1+ i)
			j (1+ j)
			w_list nil
		)

		(foreach k ent  
			(if (= 10 (car k)) (setq w_list (append w_list (list (cdr k)))))
		)
		(setq w_list (append w_list (list la)))
		(if (member w_list xy_list)
			(setq tt (1+ tt)
				a (ssdel en a)
				al (1- al)
				en (entdel en)
				i (1- i)
			)
			(setq xy_list (append xy_list (list w_list)))
		)
	)
	(princ "\n")
	(princ "\r [�ߺ��� PLine ����] ��ü PLine (")(princ i) (princ ")�� - (")(princ tt)(princ ")�� �����Ͽ����ϴ�. ")
	(command "undo" "e")
	(princ)
	)


	;-------------------------------------------------------------------------
	; 9. �ߺ��� Vertex Line ����
	;-------------------------------------------------------------------------

	(defun pxx ( / a i al tt ke j k k1 en ent xy_end xy)
	(command "undo" "g")
	(setvar "cmdecho" 0)
	(setvar "osmode" 0)
	(setq a (ssget "x" '((0 . "lwpolyline"))))
	(if (null a) (exit))
	(setq al (sslength a)
		i 0
		j 0
		k1 0
		tt 0
		)

	(while (> al i)
		(setq en (ssname a i)
			ent (entget en)
			j (1+ j)
			xy (cdr (assoc 10 ent))
			k1 0
		)

		(foreach k ent  
			(if (= 10 (car k)) (setq xy_end (cdr k) k1 (1+ k1)))
		)

		(if (and (<= k1 2) (equal xy xy_end))
			(setq tt (1+ tt)
				a (ssdel en a)
				al (1- al)
				en (entdel en)
			)
			(setq i (1+ i))
		)

	)
	(princ "\n")
	(princ "\r [�ߺ��� Vertex Line ����] ��ü Line (")(princ i) (princ ")�� - (")(princ tt)(princ ")�� �����Ͽ����ϴ�. ")
	(command "undo" "e")
	(princ)
	)


	;--------------------------------------------------------------------------------------------------
	; 10. �ߺ��� Hetch ����
	;--------------------------------------------------------------------------------------------------

	(defun get_hetch_pts(e / lst)
	 (foreach x e 
	  (if (= (car x) 10)
	   (setq lst (cons (cdr x) lst))
	  )
	 )
	 (mapcar '(lambda (x) (mapcar 'fix x)) (cdr lst))
	 )
	 
	 (defun hdd( / ss n en pts ptlst)
	 (setvar "cmdecho" 0)
	 (if (setq ss (ssget "x" '((0 . "HATCH"))))
	  (progn
	   (setq n 0)
	   (repeat (sslength ss)
		(setq     
		 en (ssname ss n)
		 pts (get_hetch_pts (entget en))
		 pts (vl-sort pts '(lambda (a b) (> (cadr a) (cadr b))))
		 pts (vl-sort pts '(lambda (a b) (< (car a) (car b))))
		)
		(if (member pts ptlst)
		 (command "erase" en "")
		 (setq ptlst (cons pts ptlst))
		)
		(setq n (1+ n))
	   )
	  )
	 )
	 (princ)
	 )


	;-------------------------------------------------------------------------
	; 11. �ߺ��� Text ����
	;    
	; ���溹 - �ߺ� text �����ϱ�
	;-------------------------------------------------------------------------

	(defun tdd ( / ss index entname_list ssn ent nn text_list ssn entt text_app text_list result leng n listobject info lengnum)
	 (setvar "cmdecho" 0)
	 (setq ss (ssget "x" '((0 . "text"))))
	 (if (/= ss nil)
	  (progn
	   (setq index 0 entname_list '() lengnum 0)
	   (setq ssn (sslength ss))   
	   (repeat ssn 
		(setq ent (entget (ssname ss index)))	
		(setq nn 0 text_list '())
		 (repeat ssn
		  (setq entt (entget (ssname ss nn)))
		  (if (and (/= index nn) (= (cdr (assoc 1 ent)) (cdr (assoc 1 entt))))
		   (progn	    
			(setq text_app (list (vl-member-if '(lambda (x) (= (cdr x) "AcDbText")) entt)))
			(setq text_list (append text_list text_app))))
			(setq nn (1+ nn)))
		(setq result (vl-position (vl-member-if '(lambda (x) (= (cdr x) "AcDbText")) ent) text_list))
		(if (/= result nil) (setq entname_list (append entname_list (list (list (cdr (assoc -1 ent)))))))
		(setq leng (length entname_list))
		(setq lengnum (/ (+ lengnum leng) 2))	
		(if (/= leng 0)
		 (progn
		  (setq n 0) 
		   (repeat leng
			(setq listobject (car (nth n entname_list)))
			(command "erase" listobject "")		
			(setq n (1+ n)))))	
		  (setq index (1+ index)))))
	 (if (/= leng 0)
	  (progn 
	   (setq info (strcat ">> �ߺ� ���� " (rtos (+ lengnum 1) 2 0) "���� �����Ͽ����ϴ�."))
	   (terpri) 
	   (prompt info))) 
	 (princ)
	)  
  

	;-------------------------------------------------------------------------
	; 12. Text �޺κ� Space ����
	;-------------------------------------------------------------------------

	(defun kDD()
	(setvar "cmdecho" 0)
	(command "undo" "g")
	(setq ss (ssget "x" '((0 . "TEXT"))))
	(if (null ss) (exit))
	(setq ssl (sslength ss)
		i 0
		k 0)
	(while (> ssl i)
		(setq en (ssname ss i)
			ent (entget en)
			tv1 (cdr (assoc 1 ent))
			tv tv1
			i (1+ i)
		)
	(if (/= tv1 "")(progn
		(setq tl 1)
		(while (= (substr tv tl 1) " ")
				(setq tv (substr tv 2))
		)
		(if (= tv "") (entdel en))
		(if (/= tv tv1)
			(setq ent (subst (cons 1 tv) (assoc 1 ent) ent)
				ent (entmod ent)
				k (1+ k))
		)
		(setq tv tv1)
		(setq tl (strlen tv))
		(while (= (substr tv tl) " ")
				(setq tv (substr tv 1 (1- tl)))
				(setq tl (1- tl))
		)	
		(if (= tv "") (entdel en))
		(if (/= tv tv1)
			(setq ent (subst (cons 1 tv) (assoc 1 ent) ent)
				ent (entmod ent)
				k (1+ k)
			)
		)
	)
	(progn
		(setq k (1+ k))
		(entdel en)
	))
	(princ "\r [Text �޺κ� Space ����] ��ü Text (")(princ i) (princ ")�� - (")(princ k)(princ ")�� �����Ͽ����ϴ�. ")
	)

	(command "undo" "e")
	(princ)
	)


	;-------------------------------------------------------------------------
	; 13. ���ɰ�ü ����
	;-------------------------------------------------------------------------
	(defun @ghost(/ k j ss ss1 en ed etn x10 x11 lis n dissum dis
	                tk tnum tss ten ted ttxt tvar @1 ttk)
	   (setvar "cmdecho" 0)
	   (prompt "\n>>������ ���� ������ü �����ϱ�<text/mtext/line/pline/>..")
	   (setq k 0 j 0 tk 0 tnum 0)
	
	 ;������ ���� text -> erase
	   (setq tss (ssadd))
	   (setq ss (ssget "x" (list (cons 0 "text,mtext"))))
	   (if ss
	      (repeat (sslength ss)
	         (setq ten (ssname ss tk))
	         (setq ted (entget ten))
	         (setq ttxt (cdr (assoc 1 ted)))
	         (setq ascii_list (vl-string->list ttxt))
		         (setq ttk 0 tvar 0)
	         (repeat (length ascii_list)
	            (setq @1 (nth ttk ascii_list))
	            (if (/= @1 32) (setq tvar 1))
	            (setq ttk (1+ ttk))
	         )
	         (if (= tvar 0) (progn (ssadd ten tss) (setq tnum (1+ tnum))))
	         (setq tk (1+ tk))
	      )
	   )
	   (if (> tnum 0) (progn (command "erase" tss "") (princ "\n->������ ���� text ") 
	         (princ tnum) (princ "��") (princ " �����Ͽ����ϴ�.")))
	;
	   (setq ss1 (ssget "x" (list (cons 0 "line,lwpolyline"))))
	   (if ss1 (progn
	      (repeat (sslength ss1)
	         (setq en (ssname ss1 k)
	                  ed (entget en)
	                  etn (cdr (assoc 0 ed)))
	         (cond ((= etn "LINE")
	            (setq x10 (cdr (assoc 10 ed))
	                     x11 (cdr (assoc 11 ed)))
	            (if (= (distance x10 x11) 0) (progn (command "erase" en "") (setq j (1+ j)))))
	            ((= etn "LWPOLYLINE")
	               (setq lis (GetPolyVtx ed))
	               (setq n 0 dissum 0)
	               (repeat (1- (length lis))
	                  (setq dis (distance (nth n lis) (nth (1+ n) lis)))
	                  (setq dissum (+ dissum dis))
	                  (setq n (1+ n))
	               )
	               (if (= dissum 0) (progn (command "erase" en "") (setq j (1+ j))))
	            )
	         );cond
	      (setq k (+ k 1))
	      );repeat
	   ));if progn
	   (if (> j 0) (progn (princ "\n->������ 0 �� ��ü ") (princ j) (princ "����") (princ " �����Ͽ����ϴ�.")))
	(princ))



	; �Ʒ����ʹ� �����Լ����� �۵��Ǵ� �������Դϴ�.
	;-------------------------------------------------------------------------
	;<- ���ν���
	   (prompt " ���� ���� �ϱ�...")
       (setq fname (subDclFile)) ; �����Լ��� ȣ���Ͽ� dclȭ���� �����Ŀ� fname������ ����
	   (setq dcl_id (load_dialog fname))
	   (setq ky 15 tg1 "1" tg2 "1" tg3 "1" tg4 "1" tg5 "1" tg6 "1" tg7 "1" tg8 "1" tg9 "1" tg10 "1" tg11 "1" tg12 "1" tg13 "1" tg14 "1")
	   (if (not (new_dialog "file_filter" dcl_id)) (exit))
	   (set_tile "tog1" tg1)(set_tile "tog2" tg2)
	   (set_tile "tog3" tg3)(set_tile "tog4" tg4)
	   (set_tile "tog5" tg5)(set_tile "tog6" tg6)
	   (set_tile "tog7" tg7)(set_tile "tog8" tg8)
	   (set_tile "tog9" tg9)(set_tile "tog10" tg10)
	   (set_tile "tog11" tg11)(set_tile "tog12" tg12)
	   (set_tile "tog13" tg13)(set_tile "tog14" tg14)
	   (action_tile "tog1" "(setq tg1 $value)")
	   (action_tile "tog2" "(setq tg2 $value)")
	   (action_tile "tog3" "(setq tg3 $value)")
	   (action_tile "tog4" "(setq tg4 $value)")
	   (action_tile "tog5" "(setq tg5 $value)")
	   (action_tile "tog6" "(setq tg6 $value)")
	   (action_tile "tog7" "(setq tg7 $value)")
	   (action_tile "tog8" "(setq tg8 $value)")
	   (action_tile "tog9" "(setq tg9 $value)")
	   (action_tile "tog10" "(setq tg10 $value)")
	   (action_tile "tog11" "(setq tg11 $value)")
	   (action_tile "tog12" "(setq tg12 $value)")
	   (action_tile "tog13" "(setq tg13 $value)")
	   (action_tile "tog14" "(setq tg14 $value)(@ff_select tg14)")
	   (action_tile "accept" "(setq ky 16)(done_dialog)")
	   (action_tile "cancel" "(done_dialog)")
	   (start_dialog)
	(if (= ky 16)(progn
	   (command "undo" "be")
	   (if (= tg1 "1") (command "audit" "y"))
	   (if (= tg2 "1") (command "hatchtoback"))	
	   (if (= tg3 "1") (command "-purge" "a" "*" "n"))
	   (if (= tg4 "1") (command "-scalelistedit" "r" "y" "e"))
	   (if (= tg5 "1") (@pointdelete))
	   (if (= tg6 "1") (@layerfilterdelete))
	   (if (= tg7 "1") (dgn))
	   (if (= tg8 "1") (pdd))
	   (if (= tg9 "1") (pxx))
	   (if (= tg10 "1") (hdd))
	   (if (= tg11 "1") (tdd))
	   (if (= tg12 "1") (kdd))
	   (if (= tg13 "1") (@ghost))
	   (command "undo" "e")
	   (command "qsave")
	   (prompt "\n>>�������� �� ���� �Ϸ�"))
	   (prompt "\n>>�����������")
	)
        (vl-file-delete fname) ;<- �ӽ÷� ������� fnameȭ���� ������ŵ�ϴ�.
	(prin1)
	;<- ��������
	;-------------------------------------------------------------------------
	)(princ)

