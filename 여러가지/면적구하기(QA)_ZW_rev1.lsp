(defun C:QA(/ ssent ds nent count sum scount txt ans lp nlp tpnt numtxt th nssent oper)
	(vl-load-com)
	(defun seterr (s)
		(if (/= s "�Լ� ���")
			(princ)
			(if (= s "quit / exit abort")
				(princ (strcat "\n����: " s))
			)
		)
		(setq *error* oer seterr nil)
		(if (/= plist nil)
			(if (= pchk "Y") ;; ��� ��� �� option�� poyline�������� ������, �����ǰԲ� ���� �ۼ�				
				(erase)
			)
		)		
		(setvar "osmode" oms)
	)
	(setq oer *error* *error* seterr)
	(GetSetting_qa) ;; ������ ��������	
	
	(setq oms (getvar "osmode"))
	
	(setvar "dimzin" 0)
	(setvar "cmdecho" 0)
	
	(setq txt 0  unctr 0 plist '() area-list '() hat_ent_lists '() cou 1 su 1 sub "add")
	
	(boun)
);defun main
	
    ;;;;;;;;;-------------------
    ;;;;;;;;; ���� ����
    ;;;;;;;;;-------------------	

(defun boun( / ent_before)
	(setq oer *error* *error* seterr)
	(setvar "osmode" 0)
	(initget 0 "Pline Text Undo Exits Subtract Add Number Option")
	(while ((or (= p "Undo") (= p "Pline") (= p "Text")(= p "Exits")(= p "Subtract")(= p "Add")(= p "Number") (= p "Option"))
		(setq p (GETPOINT (strcat "\n���� ���� Ŭ���ϼ���. [����(U)/��������(P)/���ڱ���(N)/�������ڴ�ü(T)/�ɼ�(O)/����(E)](" sub "["(rtos COU 2 0)"]): " )))
		(cond
			((= p nil)
             	(redraw (car ent_list) 4)
				(text)
				(boun)
			)
			((= p "Pline")
				(Pline)
			)
			((= p "Undo")
				(undo)
				(boun)
			)
			((= p "Subtract")
				(setq su -1)
				(setq sub "Subtract")
				(boun)
			)
			((= p "Add")
				(setq su 1)
				(setq sub "Add")
				(boun)
			)
			((= p "Number")
				(setq num(getreal "\n�����Է�: "))
				(setq ans num)
				(setq area-list (append area-list (list(cons cou ans))))
				(setq plist (append plist (list(cons cou "num"))))
				(area)
				(boun)
			)
			((= p "Text")
				(text)
				(boun)
			)
			((= p "Option")
				(create_dialog_qa)				
				(dialog_setting_qa)				
				(delete_dialog_qa)
				(boun)
			)
			((= p "Exits")
				(redraw (car ent_list) 4)
				(Exits)
			)
			((= (last p) 0)
				(setq ent_before (entlast))
				(setq pll(bpoly p))
				(if (= pll nil)
					(pline)
				)
				(if (= (entget pll) nil)
					(pline)
				)
				(setq ent_list '())
				(while (setq ent_after (entnext ent_before))
					(setq ent_list (append ent_list (list ent_after)))
					(setq ent_before ent_after)
				)
				(setq ent_n (length ent_list))
				(if (>= ent_n 2)				;������ ���� ����
					(progn
						(setq i 0 j 1)
						(setq area_list '())
						(repeat ent_n
							(setq ent_ob (nth i ent_list))							
							(command "change" ent_ob "" "P" "C" "2" "")
							(command "area" "o" ent_ob)
							(setq ans (getvar "area"))
							(setq area_list (append area_list (list ans)))
							(setq i (+ i 1))
						)
						(vl-sort area_list '>)
						(setq sum_n (length area_list))
						(setq sum_area (nth 0 area_list))
						(repeat (- sum_n 1)
							(setq sum_area (- sum_area (nth j area_list)))
							(setq j (+ j 1))
						)
						(setq area-list (append area-list (list (cons cou sum_area))))
						(setq ans (* su sum_area))
						(setq plist (append plist (list(cons cou ent_list))))
						(repeat ent_n
							(redraw (car ent_list) 3)
							(setq ent_list (cdr ent_list))
						)
					)
					(progn
						(command "change" pll "" "P" "C" "2" "")
						(command "area" "o" pll)
						(setq ans (getvar "area"))
						(setq area-list (append area-list (list(cons cou ans))))
						(setq ans (* su ans))
						(setq plist (append plist (list(cons cou ent_list))))
						(redraw (car ent_list) 3)						
					)
				)
				(if (= Ins_hat "1")	;; ��ġ ���� ���� üũ
					(progn						
						(if (/= hat_patten "SOLID")
							(progn
								(command "-hatch" "P" hat_patten hat_scale "0" p "" "")
								(setq hat_ent_list (entlast))
							)
							(progn
								(command "-hatch" "P" hat_patten p "" "")
								(setq hat_ent_list (entlast))
							)
						)
						(setq hat_ent_lists (append hat_ent_lists (list (cons cou hat_ent_list))))
					)
				)				
				(area)				
				(boun)
			)
		))
	);while

);defun

;;;;;;;;;-------------------
;;;;;;;;; ��ü ����
;;;;;;;;;-------------------	

(defun pline()
	(setq oer *error* *error* seterr)
	;(setvar "osmode" 33)
	(initget 0 "Boundary Text Undo Exits Subtract Add Number Option")
	(while ((or (= p "Undo") (= p "Boundary") (= p "Text")(= p "Exits")(= p "Subtract")(= p "Add")(= p "Number") (= p "Option"))
		(setq p (entsel (strcat "\n��ü�� Ŭ���ϼ���. (Polyline �� Hatch ����) [����(U)/����(B)/���ڱ���(N)/�������ڴ�ü(T)/�ɼ�(O)/����(E)]("sub "["(rtos COU 2 0)"]): ")))
		(if (= p nil) 
			(progn 
				(text)
				(pline)
			)
		)		
		(cond
			((= p "Boundary")
				(boun)
			)

			((= p "Undo")
				(undo)
				(pline)
			)

			((= p "Text")
				(text)
				(pline)
			)
			((= p "Subtract")
				(setq su -1)
				(setq sub "Subtract")
				(pline)
			)
			((= p "Add")
				(setq su 1)
				(setq sub "Add")
				(pline)
			)
			((= p "Number")
				(setq num(getreal "\nNumber:"))
				(setq ans num)
				(setq area-list (append area-list (list(cons cou ans))))
				(setq plist (append plist (list(cons cou "num"))))
				(area)
				(pline)
			)
			((= p "Option")
				(create_dialog_qa)				
				(dialog_setting_qa)
				(delete_dialog_qa)
				(pline)
			)
			((= p "Exits")
				(Exits)
			)
			((= (cdr (assoc 0 (entget (car p)))) "LWPOLYLINE" )			
				(setq en (car p))				
				(setq plist (append plist (list(cons cou en))))				
				(command "area" "o" en)
				(setq ans (getvar "area"))
				(setq area-list (append area-list (list (cons cou ans))))
				(redraw en 3)
				(area)
				(pline)
			)
			((= (cdr (assoc 0 (entget (car p)))) "HATCH")
				(setq en1 (car p))
				(command "-hatchedit" en1 "B" "P" "N" "")
				(setq new_pl (entlast))				
				(command "area" "o" new_pl)
				(setq plist (append plist (list(cons cou (list new_pl)))))	;; ��ü ���� ����Ʈ
				(setq ans (getvar "area"))
				(setq area-list (append area-list (list (cons cou ans))))
				(redraw new_pl 3)
				(area)
				(pline)
			)
		);cound
	)
	);while
);defun


	
;;;;;;;;;-------------------
;;;;;;;;; ��ü ����(�������� ������)
;;;;;;;;;-------------------
		
(defun erase()				;; -> ������ ������ ���� ����ó�� �ۼ��ؾ���	
	(setq count 0)
	(setq count-1 (length plist))
	(repeat count-1
		(setq pl (nth count plist))
		(if (/= hat_ent_lists nil) (setq h1 (nth count hat_ent_lists)))
		(if (/= (cdr pl) "num")
			(progn
				(setq chk (listp (setq pl (cdr pl))))				
				(if (/= chk nil)
					(progn						
						(setq n (length pl))
						(setq h (length h1))
						(repeat n
							(if (= pchk "Y")	;; �������� ��ü ���� ���� üũ
								(progn
									(entdel (car pl))
								)
								(progn			;; �������� ��ü�� �������� ���									
									(setq pent (car pl))
									(command "change" pent "" "P" "C" "bylayer" "")
									(redraw (car pl) 4)
								)
							)								
							(setq pl (cdr pl))
						)
						(if (= Del_hat "1")
							(entdel (cdr h1))
						)						
					)
					(redraw pl 4)
				)
			)
		)
		(setq count (+ count 1))
	)	
);defun

;;;;;;;;;-------------------
;;;;;;;;; ���� �հ�
;;;;;;;;;-------------------	

(defun area()
	(if (= p "Undo")
		(progn
			(setq an (nth count-area area-list)
				  pl (nth count-area plist)
			)
			(if (/= (cdr pl) "num")(entdel (cadr pl)))
			(setq area-list (vl-remove an area-list)
				  plist (vl-remove pl plist)
			)			
			(setq txt (- (abs txt) (* (/ (cdr an) 1000000) sc sc)) cou (1- cou) txt_py (* txt 0.3025))
			(setq area1 (strcat "\n       ���ܵ� ���� ����:" (rtos (* (/ (cdr an) 1000000) sc sc) 2 dpoint) "m��, " (rtos (* (/ (cdr an) 1000000) sc sc 0.3025) 2 dpoint) "��"))
			(princ area1)
		);progn
		(progn
			(if (= num nil)
				(progn
					(setq area1 (strcat "\n       ���� ����:" (rtos (* (/ ans 1000000) sc sc) 2 dpoint) "m��, " (rtos (* (/ ans 1000000) sc sc 0.3025) 2 dpoint) "��"))
					(setq txt (+ txt (* (/ ans 1000000) sc sc)))
					(setq txt_py (* txt 0.3025))
				)
				(progn
					(setq area1 (strcat "\n       ���� ����:" (rtos num 2 dpoint) "m��, " (rtos (* num 0.3025) 2 dpoint) "��"))
					(setq txt (+ txt num))
					(setq txt_py (* txt 0.3025))
				)
			)
			(setq c (princ area1))			
			(setq unctr (1+ unctr))
			(setq cou (1+ cou))
			(setq num nil)
		)
	);if
	(setq  area2 (strcat "\n ��ü ����:" (rtos txt 2 dpoint) "m��, " (rtos txt_py 2 dpoint) "��")
		   a (princ area2)
	) ; Sum Area
);defun
	
;;;;;;;;;;;--------------
;;;;;;;;;;; �ڷ� ��� 
;;;;;;;;;;;--------------
  
(defun undo ()	
	(if (> unctr 0)
		(progn			
			(setq unctr (- unctr 1))
			(setq count-area(- (length area-list) 1))			
			(area)
		)
		(prompt "�ʱ� �����Դϴ�.")
	)
)

(defun chk-AREA()
	(if (/= ent "TEXT")
		(progn
			(prompt "\n������ ��ü�� ���ڰ� �ƴմϴ�. ")
			(text-draw)
		)
	)
)

(defun text()
	(if (= txt 0)
		(progn
			(prompt "\n������ 0�Դϴ�.")
			(boun)
		)
		(text-draw)
	)
)

;;;;;;;;;-------------------
;;;;;;;;; ���� ���� ���	
;;;;;;;;;-------------------
	
(defun text-draw()
	(setq oer *error* *error* seterr)
	(if (= cunit "N")
		(progn
			(setq txts (rtos txt 2 dpoint))
			(setq txts_py (rtos txt_py 2 dpoint))
		)
		(progn
			(setq txts (strcat (rtos txt 2 dpoint) "m��"))
			(setq txts_py (strcat (rtos txt_py 2 dpoint) "��"))
		)
	)	
	(setvar "osmode" 0)	
	(if (/= P "Text")			;;�������ڴ�ü ����� �ƴҰ�� ��������
		(progn
			(initget 1)
			(setq tpnt (getpoint "\n������ ��ġ�� Ŭ�����ּ���. : "))
			(setq hstyle (cdr (assoc 40 (tblsearch "style" (getvar "TEXTSTYLE")))))
			(cond
				((= kword "M")
					(if (= hstyle 0.0)
						(command "-TEXT" tpnt height "" txts "" "")
						(command "-TEXT" tpnt "" txts "" "")
					)
				)
				((= kword "P")
					(if (= hstyle 0.0)
						(command "-TEXT" tpnt height "" txts_py "" "")
						(command "-TEXT" tpnt "" txts_py "" "")
					)
				)
				((= kword "B")
					(if (= hstyle 0.0)
						(progn
							(command "-TEXT" tpnt height "" txts "" "")
							(command "-TEXT" (list (car tpnt) (- (cadr tpnt) (* height 1.2)) 0) height "" txts_py "" "")
						)
						(progn
							(command "-TEXT" tpnt "" txts "" "")
							(command "-TEXT" (list (car tpnt) (- (cadr tpnt) (* height 1.2)) 0) "" txts_py "" "")
						)
					)
				)
			)
			
			(if (= pchk "Y") (erase))
			(setq cou 1 txt 0  unctr 0 area-list '() plist '())
			(if (= p "pline")
				(pline)
				(boun)
			)
		)
		(progn
			(setq en (entsel "\n���� ����: "))
			(if (= en nil)
				(progn
					(setq ent "LINE")
					(chk-AREA)
				)
			)
			(if (= (CDR (assoc 0 (entget (car en)))) "TEXT")
				(progn
					(cond 
						((= kword "M")
							(setq ent(cdr (assoc 0 (entget (car en)))))
							(setq new_itme (cons 1 txts))
							(setq old_itme (assoc 1 (entget (car en))))
							(setq new_ent (subst new_itme old_itme (entget (car en))))
							(entmod new_ent)
						)
						((= kword "P")
							(setq ent(cdr (assoc 0 (entget (car en)))))
							(setq new_itme (cons 1 txts_py))
							(setq old_itme (assoc 1 (entget (car en))))
							(setq new_ent (subst new_itme old_itme (entget (car en))))
							(entmod new_ent)
						)
						((= kword "B")
							(setq ent(cdr (assoc 0 (entget (car en)))))
							(setq new_itme (cons 1 txts))
							(setq old_itme (assoc 1 (entget (car en))))
							(setq new_ent (subst new_itme old_itme (entget (car en))))
							(entmod new_ent)
							
							(setq txt_xyz (cdr (assoc 10 (entget (car en)))))
							(setq height1 (cdr (assoc 40 (entget (car en)))))
							(command "-TEXT" (list (car txt_xyz) (- (cadr txt_xyz) (* height1 1.2)) 0) height1 "" txts_py "" "")
						)
					)
				)
				(chk-AREA)
			)
		)
	)
	(if (= pchk "Y") (erase))
	(setq cou 1 txt 0  unctr 0 area-list '() plist '())
)

(defun Exits()
	(setvar "osmode" oms)
	(princ "\n���� ����")
	;(exit)
)

(defun Hatch_patten_list( / file_open line tmp lst lst_2 lst_3 lst_4)
	(vl-filename-directory (findfile "zwcad.pat"))
	(setq file_open (open (findfile "zwcad.pat") "r"))
	(while (setq line (read-line file_open))
		(setq tmp (cons line tmp))
	)
	(close file_open) 
	(setq tmp (reverse tmp))
	(setq lst (vl-remove-if-not '(lambda (string) (if (eq (substr string 1 1) "*") string)) tmp))
	(setq lst_2 (mapcar '(lambda (string) (substr string 2 (- (vl-string-search "," string) 1))) lst))
	(setq lst_3 (vl-sort lst_2 '<))
	(setq lst_4 (vl-remove "SOLID" lst_3))
	(setq lst_5 (append '("SOLID") lst_4))
)

(defun SaveSetting_qa(sc height dpoint kword pchk cunit Ins_hat Del_hat hat_patten hat_scale / file_location path lenpath op)
	(setq file_location (findfile "�������ϱ� ������.txt"))
	(if (= file_location nil)
		(progn
			(setq path (findfile "ZWCAD.CUIX"))
			(setq lenpath (strlen path))
			(setq path (substr path 1 (- lenpath 10)))
			(setq file_location (strcat path "�������ϱ� ������.txt"))
		)
	)
	(setq op (open file_location "w"))
	
	(write-line (itoa sc) op)			;; �ؽ�Ʈ�� ù��° �ٿ� ������ �� �Է�
	(write-line (rtos height 2 2) op)	;; �ؽ�Ʈ�� 2��° �ٿ� ���� �� �Է�
	(write-line (itoa dpoint) op)		;; �ؽ�Ʈ�� 3��° �ٿ� �Ҽ��� �� �Է�
	(write-line kword op)				;; �ؽ�Ʈ�� 4��° �ٿ� ���� �� �Է�
	(write-line pchk op)				;; �ؽ�Ʈ�� 5��° �ٿ� �������� �������� ���� �Է�
	(write-line cunit op)				;; �ؽ�Ʈ�� 6��° �ٿ� ���� �������� ���� �Է�
	(write-line Ins_hat op)				;; �ؽ�Ʈ�� 7��° �ٿ� ��ġ ���� ���θ� ����
	(write-line Del_hat op)				;; �ؽ�Ʈ�� 8��° �ٿ� ��ġ ���� �� ���� ���� ����
	(write-line hat_patten op)			;; �ؽ�Ʈ�� 9��° �ٿ� ��ġ ���� �Է�
	(write-line (rtos hat_scale 2 3) op);; �ؽ�Ʈ�� 10��° �ٿ� ��ġ ���� �������� �Է�
	(close op)
	
	(setq sc (getvar "userr5"))
	(princ)
)

(defun GetSetting_qa( / )
	(setq fl (findfile "�������ϱ� ������.txt"))	
	(if (/= fl nil)												;; �ؽ�Ʈ ������ �����Ѵٸ�.
		(progn
			(setq op (open fl "r"))
			(while (setq setting (read-line op))				;; �ؽ�Ʈ �� �ҷ�����
				(setq data (append data (list setting)))		;; ����Ʈ���׷� data�� ����
			)
			(close op)
			(if (or (= data nil) (/= 10 (length data)))			;; ���� �ؽ�Ʈ�� ���� ���ų� �������� 6���� �ƴ� ���	
				(progn
					(setq d_sc 1000)
					(setq ds (getvar "DIMSCALE"))
					(setq th (getvar "DIMTXT"))
					(setq d_height (* th ds))
					(setq d_dpoint 2)
					(setq d_kword "M")
					(setq d_pchk "Y")
					(setq d_cunit "N")
					(setq d_Ins_hat "0")
					(setq d_Del_hat "0")
					(setq d_hat_patten "SOLID")
					(setq d_hat_scale 1.000)
					
					(setq sc d_sc)
					(setq height d_height)
					(setq dpoint d_dpoint)
					(setq kword d_kword)
					(setq pchk d_pchk)
					(setq cunit d_cunit)
					(setq Ins_hat d_Ins_hat)
					(setq Del_hat d_Del_hat)
					(setq hat_patten d_hat_patten)
					(setq hat_scale d_hat_scale)
				)
				(progn					
					(setq sc (atoi (nth 0 data)))				;; �ؽ�Ʈ 1��° ���� ���� �����´�.
					(setq height (atof (nth 1 data)))			;; �ؽ�Ʈ 2��° ���� ���� �����´�.
					(setq dpoint (atoi (nth 2 data)))			;; �ؽ�Ʈ 3��° ���� ���� �����´�.
					(setq kword (nth 3 data))					;; �ؽ�Ʈ 4��° ���� ���� �����´�.
					(setq pchk (nth 4 data))					;; �ؽ�Ʈ 5��° ���� ���� �����´�.
					(setq cunit (nth 5 data))					;; �ؽ�Ʈ 6��° ���� ���� �����´�.
					(setq Ins_hat (nth 6 data))					;; �ؽ�Ʈ 7��° ���� ���� �����´�.
					(setq Del_hat (nth 7 data))					;; �ؽ�Ʈ 8��° ���� ���� �����´�.
					(setq hat_patten (nth 8 data))				;; �ؽ�Ʈ 9��° ���� ���� �����´�.
					(setq hat_scale (atof (nth 9 data)))		;; �ؽ�Ʈ 10��° ���� ���� �����´�.
				)
			)
		)
		(progn
			(setq d_sc 1000)									;; ������ 1000����
			(setq ds (getvar "DIMSCALE"))
			(setq th (getvar "DIMTXT"))
			(setq d_height (* th ds))							;; ���ڳ���
			(setq d_dpoint 2)									;; �Ҽ��� �ڸ� 2�ڸ�
			(setq d_kword "M")									;; ������ M�� defualt
			(setq d_pchk "Y")									;; polyline ���� �⺻ ������ No
			(setq d_cunit "N")									;; ���� ���� ������ No
			(setq d_Ins_hat "0")								;; ��ġ ���� �⺻ ������ No
			(setq d_Del_hat "0")								;; ��ġ ���� ���� �⺻ ������ No
			(setq d_hat_patten "SOLID")							;; ��ġ ���� �⺻�� Solid
			(setq d_hat_scale 1.000)							;; ��ġ ������ �⺻�� 1.000
			
			(setq sc d_sc)
			(setq height d_height)
			(setq dpoint d_dpoint)
			(setq kword d_kword)
			(setq pchk d_pchk)
			(setq cunit d_cunit)
			(setq Ins_hat d_Ins_hat)
			(setq Del_hat d_Del_hat)
			(setq hat_patten d_hat_patten)
			(setq hat_scale d_hat_scale)
			
			(SaveSetting_qa sc height dpoint kword pchk cunit Ins_hat Del_hat hat_patten hat_scale)
		)
	)
	(setq data nil)
	(princ)
)

(defun dialog_setting_qa( / fname id );dcl_scale dcl_height dcl_dpoint dcl_pchk1 dcl_cunit1)
	(setq fname (findfile "�������ϱ�.dcl"))
	(setq id (load_dialog fname))
	(if (not (new_dialog "area_option" id)) (exit))
	
	(Hatch_patten_list) ;; ��ġ ���� ����Ʈ �ۼ�
	(setq hlist_num (length lst_5))
	(setq sel_hlist_num (length (member hat_patten lst_5)))
	(setq hat_num (+ 1 (- hlist_num sel_hlist_num)))
	
	
	;;;;;;;;;;;;;;;; ��ġ ��� �߰� ;;;;;;;;;;;;;;;;
	(start_list "select_hatch")				
	(mapcar 'add_list lst_5)			
	(end_list)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;DCL�� ������ ����
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(set_tile "dcl_scale" (rtos sc 2 0))
	(set_tile "dcl_txt_height" (rtos height 2 2))
	(set_tile "dcl_dpoint" (itoa dpoint))
	(set_tile "Insert_hatch" Ins_hat)
	(set_tile "Delete_Hatch" Del_hat)
	(set_tile "select_hatch" (itoa hat_num))
	(set_tile "dcl_hat_scale" (rtos hat_scale 2 3))
	
	(cond 
		((= kword "M")
			(set_tile "dcl_m" "1")
			(set_tile "dcl_py" "0")
			(set_tile "dcl_both" "0")
		)
		((= kword "P")
			(set_tile "dcl_m" "0")
			(set_tile "dcl_py" "1")
			(set_tile "dcl_both" "0")
		)
		((= kword "B")
			(set_tile "dcl_m" "0")
			(set_tile "dcl_py" "0")
			(set_tile "dcl_both" "1")
		)
	)
	(if (= pchk "Y")
		(set_tile "dcl_toggle1" "1")
		(set_tile "dcl_toggle1" "0")
	)
	(if (= cunit "Y")
		(set_tile "dcl_toggle2" "1")
		(set_tile "dcl_toggle2" "0")
	)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;DCL ������ ��������
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(action_tile "dcl_scale" "(setq dcl_scale $value )")
	(if (= dcl_scale nil)
		(setq dcl_scale (get_tile "dcl_scale"))
	)
	(action_tile "dcl_txt_height" "(setq dcl_height $value )")
	(if (= dcl_height nil)
		(setq dcl_height (get_tile "dcl_txt_height"))
	)
	(action_tile "dcl_dpoint" "(setq dcl_dpoint $value )")
	(if (= dcl_dpoint nil)
		(setq dcl_dpoint (get_tile "dcl_dpoint"))
	)

	(setq dcl_kword_m (get_tile "dcl_m"))
	(setq dcl_kword_py (get_tile "dcl_py"))
	(setq dcl_kword_both (get_tile "dcl_both"))
	
	(action_tile "dcl_m" "(setq dcl_kword_m $value dcl_kword_py \"0\" dcl_kword_both \"0\")")
	(action_tile "dcl_py" "(setq dcl_kword_py $value dcl_kword_m \"0\" dcl_kword_both \"0\")")
	(action_tile "dcl_both" "(setq dcl_kword_both $value dcl_kword_m \"0\" dcl_kword_py \"0\")")
	
	(setq dcl_pchk (get_tile "dcl_toggle1"))
	(setq dcl_cunit (get_tile "dcl_toggle2"))
	
	(action_tile "dcl_toggle1" "(setq dcl_pchk $value)")
	(action_tile "dcl_toggle2" "(setq dcl_cunit $value)")
	
	(if (= Ins_hat "0")
		(progn
			(mode_tile "Insert_hatch" 0)
			(mode_tile "Delete_Hatch" 1)
			(mode_tile "select_hatch" 1)
			(mode_tile "dcl_hat_scale" 1)
		)
		(progn
			(mode_tile "Insert_hatch" 0)
			(mode_tile "Delete_Hatch" 0)
			(mode_tile "select_hatch" 0)
			(mode_tile "dcl_hat_scale" 0)
		)
	)
	
	(action_tile "Insert_hatch" "(setq dcl_Ins_hat $value) (if (= dcl_Ins_hat \"1\") (progn (mode_tile \"Delete_Hatch\" 0) (mode_tile \"select_hatch\" 0) (mode_tile \"dcl_hat_scale\" 0)) (progn (mode_tile \"Delete_Hatch\" 1) (mode_tile \"select_hatch\" 1) (mode_tile \"dcl_hat_scale\" 1)))")	
	(action_tile "select_hatch" "(setq dcl_hat_patten (atoi $value))")
	(action_tile "Delete_Hatch" "(setq dcl_Del_hat $value)")
	(action_tile "dcl_hat_scale" "(setq dcl_hat_scale $value )")
	
	(if (= dcl_Ins_hat nil)
		(setq dcl_Ins_hat (get_tile "Insert_hatch"))
	)	
	(if (= dcl_hat_patten nil)
		(setq dcl_hat_patten (atoi (get_tile "select_hatch")))
	)
	
	(if (= dcl_Del_hat nil)
		(setq dcl_Del_hat (get_tile "Delete_Hatch"))
	)
	(if (= dcl_hat_scale nil)
		(setq dcl_hat_scale (get_tile "dcl_hat_scale"))
	)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	(setq ok (start_dialog))
	(if (= ok 1)
		(progn
			(cond
				((= dcl_kword_m "1")
					(setq dcl_kword "M")
				)
				((= dcl_kword_py "1")
					(setq dcl_kword "P")
				)
				((= dcl_kword_both "1")
					(setq dcl_kword "B")
				)
			)
			
			(if (= dcl_pchk "1") (setq dcl_pchk1 "Y") (setq dcl_pchk1 "N"))
			(if (= dcl_cunit "1") (setq dcl_cunit1 "Y") (setq dcl_cunit1 "N"))			
			
			(setq sc (atoi dcl_scale))
			(setq height (atof dcl_height))
			(setq dpoint (atoi dcl_dpoint))
			(setq kword dcl_kword)
			(setq pchk dcl_pchk1)
			(setq cunit dcl_cunit1)			
			(setq Ins_hat dcl_Ins_hat)			
			(setq Del_hat dcl_Del_hat)			
			(setq hat_patten (nth dcl_hat_patten lst_5))			
			(setq hat_scale (atof dcl_hat_scale))
			
			(SaveSetting_qa sc height dpoint kword pchk cunit Ins_hat Del_hat hat_patten hat_scale)
		)
	)
	(unload_dialog id)
	(princ)
)

(defun create_dialog_qa( / path lenpath file_location op)
	(setq path (findfile "ZWCAD.CUIX"))
	(setq lenpath (strlen path))
	(setq path (substr path 1 (- lenpath 10)))
	(setq file_location (strcat path "�������ϱ�.dcl"))
	(setq op (open file_location "w"))

	(write-line "area_option : dialog
	{ label = \"�������ϱ� �ɼ�\";
	: column
	{
		fixed_width = true;
		: boxed_column 
		{
			label = \"��°� ����\";
			aligment = centered;
			fixed_width = true;			
			children_alignment = centered;
			: row
			{
				children_aligment = right;
				: text
				{
					label = \"��ô 1: \";
					fixed_width = true;
				}
				: edit_box
				{
					key = \"dcl_scale\";
					fixed_width = true;
				}
			}
			
			: row
			{
				children_aligment = right;
				: text
				{
					label = \"���� ũ�� \";
					fixed_width = true;
				}
				: edit_box
				{
					key = \"dcl_txt_height\";
					fixed_width = true;
				}
			}
			
			: row
			{
				children_aligment = right;
				: text
				{
					label = \"�Ҽ��� ǥ��\";
					fixed_width = true;
				}
				: edit_box
				{
					key = \"dcl_dpoint\";
					fixed_width = true;
				}
			}
		}
		spacer_1;
		: boxed_radio_row
		{
			aligment = centered;			
			children_aligment = centered;
			width = 10;
			fixed_width = true;
			label = \"���� ǥ�����\";			
			: radio_button
			{
				label = \"����\";
				key = \"dcl_m\";
			}
			: radio_button
			{
				label = \"��\";
				key = \"dcl_py\";
			}
			: radio_button
			{
				label = \"�Ѵ�\";
				key = \"dcl_both\";
			}
		}
		spacer_1;
		: boxed_column
		{
			label = \"HATCH ���\";			
			: column
			{
				fixed_width = true;
				: toggle
				{
					label = \"���� ���� �� HATCH ����\";
					key = \"Insert_hatch\";
					fixed_width = true;
				}
				
				: toggle
				{
					label = \"���� �� HATCH ����\";
					key = \"Delete_Hatch\";
				}
			}
			
			: popup_list
			{
				label = \"���� : \";
				key = \"select_hatch\";					
				width = 30;
			}
			
			: row
			{
				children_aligment = left;
				: text
				{
					label = \"��ô :\";
					fixed_width = true;
				}
				: edit_box
				{
					aligment = left;
					key = \"dcl_hat_scale\";
					width = 25;
				}
			}
		}
		:toggle 
		{
			label = \"���� ���� �� ��輱(Boundary) ����\";
			key = \"dcl_toggle1\";			
		}
		
		:toggle 
		{
			label = \"���� ���� ����\";
			key = \"dcl_toggle2\";			
		}		
	}
	ok_cancel;
	}" op)
	(close op)
)
(defun delete_dialog_qa( / path)
	(vl-load-com)
	(setq path (findfile "�������ϱ�.dcl"))
	(vl-file-delete path)
	(princ)
)