/*
������������������������������������������������������������������ͻ
� VCR and TV Fault Finder                                          �
� Version 3.0 For DOS                                              �
�                                                                  �
� (C) 1995 A.J.D. Business Software                                �
�                                                                  �
� Test Module - testpi.prg                                         �
������������������������������������������������������������������ͼ
������������������������������������������������������������������ͻ
� Compiler includes                                                �
������������������������������������������������������������������ͼ
*/
#include "inkey.ch"
#include "oclip.ch"
#include "..\OBCON\control.ch"
#include "..\OBCON\obcon.ch"


LOCAL AInput     := UserInput():New()
LOCAL AProcessor := ProcessInput():New(AInput)

AProcessor:ProcessInput()

