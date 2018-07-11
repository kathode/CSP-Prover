           (*-------------------------------------------*
            |        CSP-Prover on Isabelle2004         |
            |                   July 2005               |
            |                                           |
            |        CSP-Prover on Isabelle2005         |
            |                October 2005  (modified)   |
            |                                           |
            |        CSP-Prover on Isabelle2011         |
            |                  April 2011  (modified)   |
            |                                           |
            |        CSP-Prover on Isabelle2012         |
            |               November 2012  (modified)   |
            |                                           |
            |        CSP-Prover on Isabelle2013         |
            |                   June 2013  (modified)   |
            |                                           |
            |        CSP-Prover on Isabelle2016         |
            |                    May 2016  (modified)   |
            |                                           |
            |        Yoshinao Isobe (AIST JAPAN)        |
            *-------------------------------------------*)

chapter CSP

session CSP in CSP = HOL +
  description {*
    CSP Logic.
  *}
  theories
    CSP

session CSP_T in CSP_T = CSP +
  description {*
    CSP_T Logic.
  *}
  theories
    CSP_T

session CSP_F in CSP_F = CSP_T +
  description {*
    CSP_F Logic.
  *}
  theories
    CSP_F

session DFP in DFP = CSP_F +
  description {*
    DFP Logic.
  *}
  theories
    DFP

session FNF_F in FNF_F = CSP_F +
  description {*
    FNF_F Logic.
  *}
  theories
    FNF_F
