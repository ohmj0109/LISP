(defun c:LLS( / p1 p2 p3 objs objs2 n obj dis tot_dis pl sc text_h num_size h w pp1 pp2 pp3 pp4 lp1 lp2 tp1 tp2 l_ent1 l_ent2 cen1 cen2 corners boxsize bw lay max_lay_len max_lay_name laylist dtr text_sort SaveSetting_clt GetSetting_clt create_dialog_clt delete_dialog_clt entlist set_entlist)

	;;;;;;;;;;;;;;;;;; drgree �� �������� ;;;;;;;;;;;;;
	(defun dtr(a)
		(* (/ a 180.0) pi)
	)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;;;;;;;;;;;;;;;;;; ���� ���� �Լ� ;;;;;;;;;;;;;;;;;;
	(defun text_sort(obj cen / ent text_p tb ll ur mid)
		(setq ent (entget obj))
		(setq text_p (cdr (assoc 10 ent)))
		(setq tb (textbox ent))
		(setq ll (mapcar '+ (car tb) text_p))
		(setq ur (mapcar '+ ll (mapcar '- (cadr tb) (car tb))))
		(setq mid (polar ll (angle ll ur) (/ (distance ll ur) 2.0)))
		(setq dis (mapcar '- cen mid))
		(command "_move" obj "" dis "")
	)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;;;;;;;;;;;;;;;;;;;; ������ ���� ;;;;;;;;;;;;;;;;;;;;;
	(defun SaveSetting_clt(sc height dpoint / file_location path lenpath op)
		(setq file_location (findfile "zwlisp_�ɼ�.txt"))
		(if (= file_location nil)
			(progn
				(setq path (findfile "ZWCAD.CUIX"))
				(setq lenpath (strlen path))
				(setq path (substr path 1 (- lenpath 10)))
				(setq file_location (strcat path "zwlisp_�ɼ�.txt"))
			)
		)
		(setq op (open file_location "w"))
		
		(write-line (itoa sc) op)			;; �ؽ�Ʈ�� ù��° �ٿ� ������ �� �Է�
		(write-line (rtos height 2 2) op)	;; �ؽ�Ʈ�� 2��° �ٿ� ���� �� �Է�
		(write-line (itoa dpoint) op)		;; �ؽ�Ʈ�� 3��° �ٿ� �Ҽ��� �� �Է�
		(close op)
		
		(setq sc (getvar "userr5"))
		(princ)
	)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ������ �ҷ����� ;;;;;;;;;;;;;;;;;;;;
	(defun GetSetting_clt( / )
		(setq fl (findfile "zwlisp_�ɼ�.txt"))	
		(if (/= fl nil)												;; �ؽ�Ʈ ������ �����Ѵٸ�.
			(progn
				(setq op (open fl "r"))
				(while (setq setting (read-line op))				;; �ؽ�Ʈ �� �ҷ�����
					(setq data (append data (list setting)))		;; ����Ʈ���׷� data�� ����
				)
				(close op)
				(if (or (= data nil) (/= 3 (length data)))			;; ���� �ؽ�Ʈ�� ���� ���ų� �������� 6���� �ƴ� ���	
					(progn
						(setq d_sc 1000)
						(setq ds (getvar "DIMSCALE"))
						(setq th (getvar "DIMTXT"))
						(setq d_height (* th ds))
						(setq d_dpoint 2)
						
						(setq sc d_sc)
						(setq height d_height)
						(setq dpoint d_dpoint)					
					)
					(progn					
						(setq sc (atoi (nth 0 data)))				;; �ؽ�Ʈ 1��° ���� ���� �����´�.
						(setq height (atof (nth 1 data)))			;; �ؽ�Ʈ 2��° ���� ���� �����´�.
						(setq dpoint (atoi (nth 2 data)))			;; �ؽ�Ʈ 3��° ���� ���� �����´�.					
					)
				)
			)
			(progn
				(setq d_sc 1000)									;; ������ 1000����
				(setq ds (getvar "DIMSCALE"))
				(setq th (getvar "DIMTXT"))
				(setq d_height (* th ds))							;; ���ڳ���
				(setq d_dpoint 2)									;; �Ҽ��� ǥ��
				
				(setq sc d_sc)
				(setq height d_height)
				(setq dpoint d_dpoint)			
				
				(SaveSetting_clt sc height dpoint)
			)
		)
		(setq data nil)
		(princ)
	)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;;;;;;;;;;;;;;;;;;;;;;;;; dcl ���� ;;;;;;;;;;;;;;;;;;;;;;;
	(defun create_dialog_clt( / path lenpath file_location op)
		(setq path (findfile "ZWCAD.CUIX"))
		(setq lenpath (strlen path))
		(setq path (substr path 1 (- lenpath 10)))
		(setq file_location (strcat path "zw_opton.dcl"))
		(setq op (open file_location "w"))

		(write-line "line_sum_option : dialog
		{ label = \"������ �� �ɼ�\";
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
			}
			ok_cancel;
		}" op)
		(close op)
	)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;;;;;;;;;;;;;;;;;;;;;;;; dcl ���� ���� ;;;;;;;;;;;;;;;;;;;;;;;;
	(defun delete_dialog_clt( / path)
		(vl-load-com)
		(setq path (findfile "zw_opton.dcl"))
		(vl-file-delete path)
		(princ)
	)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;;;;;;;;;;;;;;;;;;;;;;; dialog ���� ;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(defun dialog_setting_clt( / fname id );dcl_scale dcl_height dcl_dpoint dcl_pchk1 dcl_cunit1)
		(setq fname (findfile "zw_opton.dcl"))
		(setq id (load_dialog fname))
		(if (not (new_dialog "line_sum_option" id)) (exit))
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;DCL�� ������ ����
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		(set_tile "dcl_scale" (rtos sc 2 0))
		(set_tile "dcl_txt_height" (rtos height 2 2))
		(set_tile "dcl_dpoint" (itoa dpoint))

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;DCL ������ �ҷ�����
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
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		(setq ok (start_dialog))
		(if (= ok 1)
			(progn
				(setq sc (atoi dcl_scale))
				(setq height (atof dcl_height))
				(setq dpoint (atoi dcl_dpoint))
				
				(SaveSetting_clt sc height dpoint)
			)
		)
		(unload_dialog id)
		(princ)
	)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	(setvar "cmdecho" 0)
	(princ "\n���̸� ������ ��ü�� �����ϼ���.")
	(setq objs (ssget '((0 . "LINE,CIRCLE,ARC,POLYLINE,LWPOLYLINE,ELLIPSE,SPLINE"))))
	(command "undo" "be")
	(GetSetting_clt)	
	(setq tot_dis 0 laylist nil set_entlist '())
	(setq max_lay_name "���̾��" max_lay_len 4)
	
	(initget 0 "Option")
	(while (= "Option" (setq p1 (getpoint (strcat "\nǥ ���� ��ġ : < ���缳�� : ��ô=" (itoa sc) ", ���ڳ���=" (rtos height 2 2) ", �Ҽ���=" (itoa dpoint) ", �ɼǼ���(O)>" ))))
		(create_dialog_clt)
		(dialog_setting_clt)
		(delete_dialog_clt)		
	)	
	
	(if objs
		(repeat (setq n (sslength objs))
			(setq lay (cdr (assoc 8 (entget (ssname objs (setq n (1- n)))))))
			(if (> (strlen lay) max_lay_len)
				(progn
					(setq max_lay_name lay)
					(setq max_lay_len (strlen lay))
				)
			)
			(if (not (member lay laylist)) (setq laylist (cons lay laylist)))
		)
	)
  
  	(setq laylist (vl-sort laylist '<))
  
	(foreach lay laylist
		(setq entlist '())
		(repeat (setq n (sslength objs))
			(setq ent (ssname objs (setq n (1- n))))
			(setq ent_lay (cdr (assoc 8 (entget ent))))
			(if (= ent_lay lay)				
				(setq entlist (append (list ent) entlist))
			)
		)
		(setq set_entlist (append set_entlist (list entlist)))
	)
	;(setq lay (list "LINE" "CIRCLE" "ARC" "POLYLINE" "LWPOLYLINE" "ELLISPE" "SPLINE"))
	
	(setq corners (textbox (list (cons 1 max_lay_name) (cons 40 height))))
    (setq boxsize (mapcar '- (cadr corners) (car corners)))
    (setq bw (fix (car boxsize)))
	
	(setq hstyle (cdr (assoc 40 (tblsearch "style" (getvar "TEXTSTYLE"))))) ;; ���� ��Ÿ�Ͽ� ���̰��� ���ǰ� �Ǿ��ִ����� ���� �ؽ�Ʈ�� ��������� ������ �޶���
	(if (= hstyle 0.0)
		(setq h (* height 2))
		(setq h (* hstyle 2))
	)
	(setq w (* 2 (+ bw h)))
	;(setq w (* h 8))
	
	(setq pp1 (polar p1 0 w)) ;; ���� ��� ����Ʈ
	(setq pp2 (polar pp1 (dtr 270) h)) ;; ���� �ϴ� ����Ʈ
	(setq pp3 (polar pp2 (dtr 180) w)) ;; ���� �ϴ� ����Ʈ
	(setq pp4 (polar pp3 (dtr 90) h)) ;; ���� ��� ����Ʈ
	
	(setq lp1 (polar pp4 (dtr 0) (/ w 2))) ;; ���� ��� �ߴ� ����Ʈ
	(setq lp2 (polar pp3 (dtr 0) (/ w 2))) ;; ���� �ϴ� �ߴ� ����Ʈ
	
	(setq tp1 (polar lp2 (dtr 45) (/ w 8))) ;; ������ ����
	(setq tp2 (polar pp3 (dtr 45) (/ w 8))) ;; ���� ����
	
	(setvar "cmdecho" 0)
	;; ���̺� ��� �ּ�
	(command "pline" pp1 pp2 pp3 pp4 "c" "")
	(command "line" lp1 lp2 "")
	;(setq bname (cdr (assoc 2 (entget (car ent)))))
	(if (= hstyle 0.0)
		(command "text" tp2 height "" "���̾��" "")
		(command "text" tp2 "" "���̾��" "")
	)
	(setq l_ent1 (entlast))
	(if (= hstyle 0.0)
		(command "text" tp1 height "" "����" "")
		(command "text" tp1 "" "����" "")
	)
	(setq l_ent2 (entlast))
	
	(setq cen1 (polar pp3 (angle pp3 lp1) (/ (distance pp3 lp1) 2))) ;; ���� ���ڿ� ���� �簢���� ���� ����Ʈ
	(setq cen2 (polar lp2 (angle lp2 pp1) (/ (distance lp2 pp1) 2))) ;; ������ ���ڿ� ���� �簢���� ���� ����Ʈ
	
	(text_sort l_ent1 cen1)
	(text_sort l_ent2 cen2)
	
	(foreach lay laylist
		(setq entlist (car set_entlist))
		(setq tl 0)
		(repeat (length entlist)
			(setq ent (car entlist))
			(setq tl (+ tl (vlax-curve-getDistAtParam ent (vlax-curve-getEndParam ent))))
			(setq entlist (cdr entlist))
		)
		(setq pp1 (polar pp3 0 w)) ;; ���� ��� ����Ʈ
		(setq pp2 (polar pp1 (dtr 270) h)) ;; ���� �ϴ� ����Ʈ
		(setq pp3 (polar pp2 (dtr 180) w)) ;; ���� �ϴ� ����Ʈ
		(setq pp4 (polar pp3 (dtr 90) h)) ;; ���� ��� ����Ʈ
		
		(setq lp1 (polar pp4 (dtr 0) (/ w 2))) ;; ���� ��� �ߴ� ����Ʈ
		(setq lp2 (polar pp3 (dtr 0) (/ w 2))) ;; ���� �ϴ� �ߴ� ����Ʈ
		
		(setq tp1 (polar lp2 (dtr 45) (/ w 8))) ;; ������ ����
		(setq tp2 (polar pp3 (dtr 45) (/ w 8))) ;; ���� ����
		
		(setvar "cmdecho" 0)
		(command "pline" pp1 pp2 pp3 pp4 "c" "")
		(command "line" lp1 lp2 "")
		
		(if (= hstyle 0.0)
			(command "text" tp2 height "" lay "")
			(command "text" tp2 "" lay "")
		)
		(setq l_ent1 (entlast))
		(setq tl (rtos (* (/ tl 1000) sc) 2 dpoint))
		(if (= hstyle 0.0)
			(command "text" tp1 height "" tl "")
			(command "text" tp1 "" tl "")
		)
		(setq l_ent2 (entlast))
		
		(setq cen1 (polar pp3 (angle pp3 lp1) (/ (distance pp3 lp1) 2))) ;; ���� ���ڿ� ���� �簢���� ���� ����Ʈ
		(setq cen2 (polar lp2 (angle lp2 pp1) (/ (distance lp2 pp1) 2))) ;; ������ ���ڿ� ���� �簢���� ���� ����Ʈ
		
		(text_sort l_ent1 cen1)
		(text_sort l_ent2 cen2)
		
		(setq set_entlist (cdr set_entlist))
	)	
	(command "undo" "end")
	(setvar "cmdecho" 1)
	(princ)
)






