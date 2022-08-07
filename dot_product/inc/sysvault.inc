; @file   sysvault.inc
; @author Pedro Botelho
; @brief  Some useful system calls and functions
;         for managing files as well as devices
;         and memory.

%IFNDEF SYSVAULT_H
%DEFINE SYSVAULT_H

EXTERN sysvOpenFile

EXTERN sysvCloseFile

EXTERN sysvReadFileLine

EXTERN sysvClearMemory

EXTERN sysvGetFileLineInteger

EXTERN sysvGetFileLineDouble

%ENDIF