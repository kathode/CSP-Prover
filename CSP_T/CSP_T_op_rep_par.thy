           (*-------------------------------------------*
            |        CSP-Prover on Isabelle2004         |
            |                    May 2005               |
            |                   June 2005  (modified)   |
            |              September 2005  (modified)   |
            |                                           |
            |        CSP-Prover on Isabelle2005         |
            |                October 2005  (modified)   |
            |                  April 2006  (modified)   |
            |                  March 2007  (modified)   |
            |                                           |
            |        CSP-Prover on Isabelle2016         |
            |                    May 2016  (modified)   |
            |                                           |
            |        Yoshinao Isobe (AIST JAPAN)        |
            *-------------------------------------------*)

theory CSP_T_op_rep_par
imports CSP_T_op_alpha_par
begin

(*  The following simplification rules are deleted in this theory file *)
(*  because they unexpectly rewrite UnionT and InterT.                 *)
(*                  Union (B ` A) = (UN x:A. B x)                      *)
(*                  Inter (B ` A) = (INT x:A. B x)                     *)


declare Sup_image_eq [simp del]
declare Inf_image_eq [simp del]

(*  The following simplification rules are deleted in this theory file *)
(*  because they unexpectly rewrite (notick | t = <>)                  *)
(*                                                                     *)
(*                  disj_not1: (~ P | Q) = (P --> Q)                   *)

declare disj_not1 [simp del]

(*============================================================*
 |                                                            |
 |            replicated alphabetized parallel                |
 |                                                            |
 *============================================================*)

(*** traces Inductive_parallel ***)

lemma in_traces_Inductive_parallel_lm1: 
  "(P, X) : set PXs ==> X <= Union (snd ` (set PXs))"
by (auto)

(* main *)

lemma in_traces_Inductive_parallel_lm:
  "PXs ~= [] --> (ALL u.
    (u :t traces ([||] PXs) M) =
     (sett(u) <= insert Tick (Ev ` (Union (snd ` (set PXs)))) & 
      (ALL P X. (P,X):(set PXs) --> (u rest-tr X) :t traces P M)))"
apply (induct_tac PXs)

(* case 0 *)
 apply (simp)

(* case 1 *)
 apply (case_tac "list = []")
 apply (simp)
 apply (intro allI)
 apply (simp add: in_traces_Alpha_parallel in_traces)
 apply (simp add: pair_eq_decompo)
 apply (simp add: rest_tr_empty)
 apply (rule iffI)
 (* => *)
  apply (simp)
 (* <= *)
  apply (simp)

(* step case *)
apply (simp add: in_traces_Alpha_parallel)
apply (intro allI impI)
apply (rule iffI)

(* => *)
 apply (simp)
 apply (intro allI)
 apply (rule conjI)

  apply (intro impI)
  apply (simp add: pair_eq_decompo)

  apply (intro impI)
  apply (elim conjE)
  apply (drule_tac x="P" in spec)
  apply (drule_tac x="X" in spec)
  apply (subgoal_tac "X <= Union (snd ` set list)")
  apply (simp add: rest_tr_of_rest_tr_subset)
  apply (simp add: in_traces_Inductive_parallel_lm1)

(* <= *)
 apply (simp add: rest_tr_sett_subseteq_sett)
 apply (intro allI impI)
 apply (elim conjE)
 apply (drule_tac x="P" in spec)
 apply (drule_tac x="X" in spec)
 apply (subgoal_tac "X <= Union (snd ` set list)")
 apply (simp add: rest_tr_of_rest_tr_subset)
 apply (simp add: in_traces_Inductive_parallel_lm1)
done

(*** remove ALL ***)

lemma in_traces_Inductive_parallel:
  "PXs ~= [] 
   ==> (u :t traces ([||] PXs) M) =
       (sett(u) <= insert Tick (Ev ` (Union (snd ` (set PXs)))) & 
        (ALL P X. (P,X):(set PXs) --> (u rest-tr X) :t traces P M))"
by (simp add: in_traces_Inductive_parallel_lm)

(*** Semantics for replicated alphabetized parallel on T ***)

lemma traces_Inductive_parallel:
  "PXs ~= []
   ==> traces ([||] PXs) M =
       {u. sett(u) <= insert Tick (Ev ` (Union (snd ` (set PXs)))) & 
        (ALL P X. (P,X):(set PXs) --> (u rest-tr X) :t traces P M)}t"
apply (simp add: in_traces_Inductive_parallel[THEN sym])
done

(************************************
 |              traces              |
 ************************************)

lemma sett_in_traces_Inductive_parallel:
  "[| PXs ~= [] ; t :t traces ([||] PXs) M |] 
   ==> sett t <= insert Tick (Ev ` Union (snd ` set PXs))"
by (simp add: in_traces_Inductive_parallel)

(*---------------------------------------------------------*
 |        another expression of Inductive_parallel_eval          |
 *---------------------------------------------------------*)

lemma in_traces_Inductive_parallel_nth:
  "PXs ~= [] 
   ==> (u :t traces ([||] PXs) M) =
       (sett(u) <= insert Tick (Ev ` (Union (snd ` (set PXs)))) & 
        (ALL i. i < length PXs --> (u rest-tr (snd (PXs!i))) :t traces (fst (PXs!i)) M))"
apply (simp add: in_traces_Inductive_parallel)
apply (simp add: set_nth)
apply (simp add: pair_eq_decompo)
by (auto)

(*============================================================*
 |                                                            |
 |              indexed alphabetized parallel                 |
 |                                                            |
 *============================================================*)

(*** index_style ***)

lemma to_index_style_T:
   "(ALL P X. (P,X):(PXf ` I) --> (u rest-tr X) :t traces P M)
  = (ALL i:I. u rest-tr (snd (PXf i)) :t traces (fst (PXf i)) M)"
apply (auto)
apply (simp add: pair_eq_decompo)
done

(*** in_traces_Rep_parallel (pre) ***)

lemma in_traces_Rep_parallel_pre:
  "[| I ~= {} ; finite I |]
   ==> (u :t traces ([||]:I PXf) M) =
       (sett(u) <= insert Tick (Ev ` (Union (snd ` PXf ` I))) & 
        (ALL P X. (P,X):PXf ` I --> (u rest-tr X) :t traces P M))"
apply (simp add: Rep_parallel_def)
apply (subgoal_tac "EX Is. Is isListOf I")
apply (elim conjE exE)
apply (subgoal_tac "(map PXf (SOME Is. Is isListOf I)) ~= []")
apply (simp add: in_traces in_traces_Inductive_parallel)
apply (rule someI2)
 apply (simp)
 apply (simp add: isListOf_set_eq)

apply (rule someI2)
 apply (simp)
 apply (simp add: isListOf_nonemptyset)

apply (simp add: isListOf_EX)
done

(*** in_traces_Rep_parallel ***)

lemma in_traces_Rep_parallel:
  "[| I ~= {} ; finite I |]
   ==> (u :t traces ([||]:I PXf) M) =
       (sett(u) <= insert Tick (Ev ` (Union (snd ` PXf ` I))) & 
        (ALL i:I. (u rest-tr (snd (PXf i))) :t traces (fst (PXf i)) M))"
apply (simp add: in_traces_Rep_parallel_pre)
apply (simp add: to_index_style_T)
done

lemmas in_traces_par = in_traces_Alpha_parallel
                       in_traces_Inductive_parallel
                       in_traces_Rep_parallel

(*** Semantics for indexed alphabetized parallel on T ***)

lemma traces_Rep_parallel:
  "[| I ~= {} ; finite I |]
   ==> traces ([||]:I PXf) M =
             {u. (sett(u) <= insert Tick (Ev ` (Union (snd ` PXf ` I))) & 
              (ALL i:I. (u rest-tr (snd (PXf i))) :t traces (fst (PXf i)) M))}t"
apply (simp add: in_traces_Rep_parallel[THEN sym])
done

(************************************
 |              traces              |
 ************************************)

lemma sett_in_traces_Rep_parallel:
  "[| I ~= {} ; finite I ; t :t traces ([||]:I PXf) M |] 
   ==> sett t <= insert Tick (Ev ` Union (snd ` PXf ` I))"
by (simp add: in_traces_Rep_parallel)

(****************** to add it again ******************)

declare disj_not1   [simp]
(*
declare Union_image_eq [simp]
declare Inter_image_eq [simp]
*)

declare Sup_image_eq [simp]
declare Inf_image_eq [simp]

end
