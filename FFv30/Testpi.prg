/*
浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融
� VCR and TV Fault Finder                                          �
� Version 3.0 For DOS                                              �
�                                                                  �
� (C) 1995 A.J.D. Business Software                                �
�                                                                  �
� Test Module - testpi.prg                                         �
藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕
浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融
� Compiler includes                                                �
藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕
*/
#include "inkey.ch"
#include "oclip.ch"
#include "..\OBCON\control.ch"
#include "..\OBCON\obcon.ch"


LOCAL AInput     := UserInput():New()
LOCAL AProcessor := ProcessInput():New(AInput)

AProcessor:ProcessInput()

