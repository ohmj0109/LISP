;;program name : ĳ�峻 ��Ģ�������α׷� ver 1.0
;;program : +, -, /, * ������ �ؽ�Ʈ ��� �� ��


(defun exe_1()
   (setvar "cmdecho" 0)
   (setvar "blipmode" 0)
   (setq e1 (entsel "\n>>ù��°���ڼ���:"))
   (setq a (car e1);;----------��ƼƼ�� �̸���
         b (entget a);;--------��ƼƼ�� ����Ʈ��
         txt1 (assoc 1 b);;----��ƼƼ�� �ش� ���ڿ� ����Ʈ
         tt1 (cdr txt1);;------��ƼƼ ���ڿ��� ����Ʈ�� ���ǰ�="���ڿ�"
         sum1 (atof tt1);;-----��ƼƼ�� ���ڿ��� ������ ��ȯ=100
         txth1 (assoc 40 b);;--��ƼƼ ����Ʈ�� �ؽ�Ʈ ������ ����Ʈ��(40,100)
         thh (cdr txth1);;-----��ƼƼ�� �ؽ�Ʈ������ ����Ʈ�� ���ǰ�=100
   )          
   (setq e2 (entsel "\n>>�ι�°���ڼ���:"))
   (setq aa (car e2)
         bb (entget aa)
         txt2 (assoc 1 bb)
         tt2 (cdr txt2)
         sum2 (atof tt2)
         )
    (setq tl (assoc 8 b)
          txtst (cdr tl)
    )
)

(defun exe+()
   (setq sum (+ sum1 sum2))
   (setq summ (rtos sum 2 3))
   (setq p1 (getpoint "\n>>ǥ���� ����Ʈ���:"))
   (command "text" p1 thh 0 summ)
     
 )
(defun exe-()
   (setq sum (- sum1 sum2))
   (setq summ (rtos sum 2 3))
   (setq p1 (getpoint "\n>>ǥ���� ����Ʈ���:"))
   (command "text" p1 thh 0 summ)
  
)

 
 (defun exe*()
    (setq sum (* sum1 sum2))
    (setq summ (rtos sum 2 3))
    (setq p1 (getpoint "\n>>ǥ���� ����Ʈ���:"))
    (command "text" p1 thh 0 summ)
 )

 (defun exe/()
    (setq sum (/ sum1 sum2))
    (setq summ (rtos sum 2 3))
    (setq p1 (getpoint "\n>>ǥ���� ����Ʈ���:"))
    (command "text" p1 thh 0 summ)
 )
 (defun exe%()
    (setq sum (* (/ sum1 sum2) 100))
    (setq summ (rtos sum 2 3))
    (setq p1 (getpoint "\n>>ǥ���� ����Ʈ���:"))
    (command "text" p1 thh 0 summ)
 )

(defun c:+( / e1 a b txt1 tt1 sum1 txth1 thh e2 aa bb txt2 tt2 sum2 tl txtst sum summ p1)
  (exe_1)
  (exe+)
  (princ)
)
(defun c:-( / e1 a b txt1 tt1 sum1 txth1 thh e2 aa bb txt2 tt2 sum2 tl txtst sum summ p1)
   (exe_1)
   (exe-)
   (princ)
)
(defun c:*( / e1 a b txt1 tt1 sum1 txth1 thh e2 aa bb txt2 tt2 sum2 tl txtst sum summ p1)
   (exe_1)
   (exe*)
   (princ)
)
(defun c:/( / e1 a b txt1 tt1 sum1 txth1 thh e2 aa bb txt2 tt2 sum2 tl txtst sum summ p1)
  (exe_1)
  (exe/)
  (princ)
)
(defun c:%( / e1 a b txt1 tt1 sum1 txth1 thh e2 aa bb txt2 tt2 sum2 tl txtst sum summ p1)
  (exe_1)
  (exe%)
  (princ)
)
(defun c:py( / e1 a b txt1 tt1 sum1 txth1 thh sum summ p1 )
   (setvar "cmdecho" 0)
   (setvar "blipmode" 0)
   (setq e1 (entsel "\n>>���ڼ���:"))
   (setq a (car e1);;----------��ƼƼ�� �̸���
         b (entget a);;--------��ƼƼ�� ����Ʈ��
         txt1 (assoc 1 b);;----��ƼƼ�� �ش� ���ڿ� ����Ʈ
         tt1 (cdr txt1);;------��ƼƼ ���ڿ��� ����Ʈ�� ���ǰ�="���ڿ�"
         sum1 (atof tt1);;-----��ƼƼ�� ���ڿ��� ������ ��ȯ=100
         txth1 (assoc 40 b);;--��ƼƼ ����Ʈ�� �ؽ�Ʈ ������ ����Ʈ��(40,100)
         thh (cdr txth1);;-----��ƼƼ�� �ؽ�Ʈ������ ����Ʈ�� ���ǰ�=100
   ) 
    (setq sum (* sum1 0.3025))
    (setq summ (rtos sum 2 3))
    (setq zz (strcat "(" summ ")"))
    (setq p1 (getpoint "\n>>ǥ���� ����Ʈ���:"))
    (command "text" p1 thh 0 zz)
(princ)
)

(defun c:+( / sum_m ss ok e ent sum_ p1 txth1 thh summ ) 
 (setvar "cmdecho" 0)
 (setvar "blipmode" 0)
 (setq sum_m 0)
  (setq SS (ssget))
  (setq ok 0)
  (while 
    (setq e (ssname ss ok))
    (setq ent (entget e))
    (setq sum_ (assoc 1 ent))
    (setq sum_ (cdr sum_))
    (setq sum_ (atof sum_))
    (setq sum_m (+ sum_m sum_))
    (setq ok (1+ ok))
  )
 (setq p1 (getpoint "\n>>ǥ���� ����Ʈ���:"))
    (setq txth1 (assoc 40 ent))
    (setq thh (cdr txth1))
    (setq summ (rtos sum_m 2 3))
    (command "text" p1 thh 0 summ)
(princ)       
)

(defun c:*( / sum_m ss ok e ent sum_ p1 txth1 thh summ ) 
 (setvar "cmdecho" 0)
 (setvar "blipmode" 0)
 (setq sum_m 1)
  (setq SS (ssget))
  (setq ok 0)
  (while 
    (setq e (ssname ss ok))
    (setq ent (entget e))
    (setq sum_ (assoc 1 ent))
    (setq sum_ (cdr sum_))
    (setq sum_ (atof sum_))
    (setq sum_m (* sum_m sum_))
    (setq ok (1+ ok))
  )
 (setq p1 (getpoint "\n>>ǥ���� ����Ʈ���:"))
    (setq txth1 (assoc 40 ent))
    (setq thh (cdr txth1))
    (setq summ (rtos sum_m 2 3))
    (command "text" p1 thh 0 summ)
(princ)       
)
(princ "\n>>��Ģ���� ���α׷� �ε��Ϸ� command : +,-,*,/,%,py,++,**")
(princ)











































































































