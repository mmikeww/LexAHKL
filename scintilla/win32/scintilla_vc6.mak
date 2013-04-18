# Make file for Scintilla on Windows Visual C++ version
# Copyright 1998-2010 by Neil Hodgson <neilh@scintilla.org>
# The License.txt file describes the conditions under which this software may be distributed.
# This makefile is for using Visual C++ with nmake.
# Usage for Microsoft:
#     nmake -f scintilla.mak
# For debug versions define DEBUG on the command line:
#     nmake DEBUG=1 -f scintilla.mak
# The main makefile uses mingw32 gcc and may be more current than this file.

.SUFFIXES: .cxx

DIR_O=.
DIR_BIN=..\bin

COMPONENT=$(DIR_BIN)\Scintilla.dll
LEXCOMPONENT=$(DIR_BIN)\SciLexer.dll

CC=cl
RC=rc
LD=link

#-Zc:forScope -Zc:wchar_t
CXXFLAGS=-Zi -TP -W3 -EHsc
# For something scary:-Wp64
CXXDEBUG=-Od -MTd -DDEBUG
CXXNDEBUG=-O1 -MT -DNDEBUG
NAME=-Fo
# If you have problems with lexers being linked, try removing -OPT:REF and replacing with -OPT:NOREF
LDFLAGS=-OPT:NOWIN98 -OPT:REF
LDDEBUG=
LIBS=KERNEL32.lib USER32.lib GDI32.lib IMM32.lib OLE32.LIB
NOLOGO=-nologo

!IFDEF QUIET
CC=@$(CC)
CXXFLAGS=$(CXXFLAGS) $(NOLOGO)
LDFLAGS=$(LDFLAGS) $(NOLOGO)
!ENDIF

!IFDEF DEBUG
CXXFLAGS=$(CXXFLAGS) $(CXXDEBUG)
LDFLAGS=$(LDDEBUG) $(LDFLAGS)
!ELSE
CXXFLAGS=$(CXXFLAGS) $(CXXNDEBUG)
!ENDIF

INCLUDEDIRS=-I../include -I../src -I../lexlib
CXXFLAGS=$(CXXFLAGS) $(INCLUDEDIRS)

ALL:	$(COMPONENT) $(LEXCOMPONENT) $(DIR_O)\ScintillaWinS.obj

clean:
	-del /q $(DIR_O)\*.obj $(DIR_O)\*.pdb $(COMPONENT) $(LEXCOMPONENT) \
	$(DIR_O)\*.res $(DIR_BIN)\*.map $(DIR_BIN)\*.exp $(DIR_BIN)\*.pdb $(DIR_BIN)\*.lib

SOBJS=\
	$(DIR_O)\AutoComplete.obj \
	$(DIR_O)\CallTip.obj \
	$(DIR_O)\CellBuffer.obj \
	$(DIR_O)\CharacterSet.obj \
	$(DIR_O)\CharClassify.obj \
	$(DIR_O)\ContractionState.obj \
	$(DIR_O)\Decoration.obj \
	$(DIR_O)\Document.obj \
	$(DIR_O)\Editor.obj \
	$(DIR_O)\Indicator.obj \
	$(DIR_O)\KeyMap.obj \
	$(DIR_O)\LineMarker.obj \
	$(DIR_O)\PerLine.obj \
	$(DIR_O)\PlatWin.obj \
	$(DIR_O)\PositionCache.obj \
	$(DIR_O)\PropSetSimple.obj \
	$(DIR_O)\RESearch.obj \
	$(DIR_O)\RunStyles.obj \
	$(DIR_O)\ScintillaBase.obj \
	$(DIR_O)\ScintillaWin.obj \
	$(DIR_O)\Selection.obj \
	$(DIR_O)\Style.obj \
	$(DIR_O)\UniConversion.obj \
	$(DIR_O)\ViewStyle.obj \
	$(DIR_O)\XPM.obj

#++Autogenerated -- run src/LexGen.py to regenerate
#**LEXOBJS=\\\n\(\t$(DIR_O)\\\*.obj \\\n\)
LEXOBJS=\
	$(DIR_O)\LexAHKL.obj \

#--Autogenerated -- end of automatically generated section

LOBJS=\
	$(DIR_O)\Accessor.obj \
	$(DIR_O)\AutoComplete.obj \
	$(DIR_O)\CallTip.obj \
	$(DIR_O)\Catalogue.obj \
	$(DIR_O)\CellBuffer.obj \
	$(DIR_O)\CharacterSet.obj \
	$(DIR_O)\CharClassify.obj \
	$(DIR_O)\ContractionState.obj \
	$(DIR_O)\Decoration.obj \
	$(DIR_O)\Document.obj \
	$(DIR_O)\Editor.obj \
	$(DIR_O)\ExternalLexer.obj \
	$(DIR_O)\Indicator.obj \
	$(DIR_O)\KeyMap.obj \
	$(DIR_O)\LexerBase.obj \
	$(DIR_O)\LexerModule.obj \
	$(DIR_O)\LexerSimple.obj \
	$(DIR_O)\LineMarker.obj \
	$(DIR_O)\PerLine.obj \
	$(DIR_O)\PlatWin.obj \
	$(DIR_O)\PositionCache.obj \
	$(DIR_O)\PropSetSimple.obj \
	$(DIR_O)\RESearch.obj \
	$(DIR_O)\RunStyles.obj \
	$(DIR_O)\ScintillaBaseL.obj \
	$(DIR_O)\ScintillaWinL.obj \
	$(DIR_O)\Selection.obj \
	$(DIR_O)\Style.obj \
	$(DIR_O)\StyleContext.obj \
	$(DIR_O)\UniConversion.obj \
	$(DIR_O)\ViewStyle.obj \
	$(DIR_O)\WordList.obj \
	$(DIR_O)\XPM.obj \
	$(LEXOBJS)

$(DIR_O)\ScintRes.res : ScintRes.rc
	$(RC) -fo$@ $**

$(COMPONENT): $(SOBJS) $(DIR_O)\ScintRes.res
	$(LD) $(LDFLAGS) -DEF:Scintilla.def -DLL -OUT:$@ $** $(LIBS)

$(LEXCOMPONENT): $(LOBJS) $(DIR_O)\ScintRes.res
	$(LD) $(LDFLAGS) -DEF:Scintilla.def -DLL -OUT:$@ $** $(LIBS)

# Define how to build all the objects and what they depend on

{..\src}.cxx{$(DIR_O)}.obj:
	$(CC) $(CXXFLAGS) -c $(NAME)$@ $<
{..\lexlib}.cxx{$(DIR_O)}.obj:
	$(CC) $(CXXFLAGS) -c $(NAME)$@ $<
{..\lexers}.cxx{$(DIR_O)}.obj:
	$(CC) $(CXXFLAGS) -c $(NAME)$@ $<
{.}.cxx{$(DIR_O)}.obj:
	$(CC) $(CXXFLAGS) -c $(NAME)$@ $<

# Some source files are compiled into more than one object because of different conditional compilation
$(DIR_O)\ScintillaBaseL.obj: ..\src\ScintillaBase.cxx
	$(CC) $(CXXFLAGS) -DSCI_LEXER -c $(NAME)$@ ..\src\ScintillaBase.cxx

$(DIR_O)\ScintillaWinL.obj: ScintillaWin.cxx
	$(CC) $(CXXFLAGS) -DSCI_LEXER -c $(NAME)$@ ScintillaWin.cxx

$(DIR_O)\ScintillaWinS.obj: ScintillaWin.cxx
	$(CC) $(CXXFLAGS) -DSTATIC_BUILD -c $(NAME)$@ ScintillaWin.cxx

# Dependencies

# All lexers depend on this set of headers
LEX_HEADERS= ..\include\ILexer.h ..\include\Scintilla.h ..\include\SciLexer.h \
 ..\lexlib\Accessor.h ..\lexlib\CharacterSet.h ..\lexlib\LexAccessor.h \
 ..\lexlib\LexerModule.h ..\lexlib\StyleContext.h

$(DIR_O)\AutoComplete.obj: ../src/AutoComplete.cxx ../include/Platform.h \
  ../src/AutoComplete.h
$(DIR_O)\Accessor.obj: ../lexlib/Accessor.cxx ../lexlib/Accessor.h
$(DIR_O)\CallTip.obj: ../src/CallTip.cxx ../include/Platform.h \
  ../include/Scintilla.h ../src/CallTip.h
$(DIR_O)\CellBuffer.obj: ../src/CellBuffer.cxx ../include/Platform.h \
  ../include/Scintilla.h ../src/SVector.h ../src/SplitVector.h \
  ../src/Partitioning.h ../src/CellBuffer.h
$(DIR_O)\CharacterSet.obj: ../lexlib/CharacterSet.cxx ../lexlib/CharacterSet.h
$(DIR_O)\CharClassify.obj: ../src/CharClassify.cxx ../src/CharClassify.h
$(DIR_O)\ContractionState.obj: ../src/ContractionState.cxx ../include/Platform.h \
  ../src/ContractionState.h
$(DIR_O)\Decoration.obj: ../src/Decoration.cxx ../include/Platform.h \
  ../include/Scintilla.h ../src/SplitVector.h ../src/Partitioning.h \
  ../src/RunStyles.h ../src/Decoration.h
$(DIR_O)\Document.obj: ../src/Document.cxx ../include/Platform.h \
  ../include/Scintilla.h ../src/SVector.h ../src/SplitVector.h \
  ../src/Partitioning.h ../src/RunStyles.h ../src/CellBuffer.h \
  ../src/CharClassify.h ../src/Decoration.h ../src/Document.h \
  ../src/RESearch.h ../src/PerLine.h
$(DIR_O)\Editor.obj: ../src/Editor.cxx ../include/Platform.h ../include/Scintilla.h \
  ../src/ContractionState.h ../src/SVector.h ../src/SplitVector.h \
  ../src/Partitioning.h ../src/CellBuffer.h ../src/KeyMap.h \
  ../src/RunStyles.h ../src/Indicator.h ../src/XPM.h ../src/LineMarker.h \
  ../src/Style.h ../src/ViewStyle.h ../src/CharClassify.h \
  ../src/Decoration.h ../src/Document.h ../src/Editor.h ../src/Selection.h ../src/PositionCache.h
$(DIR_O)\ExternalLexer.obj: ../src/ExternalLexer.cxx ../include/Platform.h \
  ../include/Scintilla.h ../include/SciLexer.h \
  ../lexlib/Accessor.h ../src/ExternalLexer.h
$(DIR_O)\Indicator.obj: ../src/Indicator.cxx ../include/Platform.h \
  ../include/Scintilla.h ../src/Indicator.h
$(DIR_O)\KeyMap.obj: ../src/KeyMap.cxx ../include/Platform.h ../include/Scintilla.h \
  ../src/KeyMap.h

#++Autogenerated -- run src/LexGen.py to regenerate
#**\n\($(DIR_O)\\\*.obj: ..\\lexers\\\*.cxx $(LEX_HEADERS)\n\n\)

$(DIR_O)\LexAHKL.obj: ..\lexers\LexAHKL.cxx $(LEX_HEADERS)


#--Autogenerated -- end of automatically generated section

$(DIR_O)\LexerBase.obj: ../lexlib/LexerBase.cxx ../lexlib/LexerBase.h
$(DIR_O)\LexerModule.obj: ../lexlib/LexerModule.cxx ../lexlib/LexerModule.h
$(DIR_O)\LexerSimple.obj: ../lexlib/LexerSimple.cxx ../lexlib/LexerSimple.h
$(DIR_O)\LineMarker.obj: ../src/LineMarker.cxx ../include/Platform.h \
  ../include/Scintilla.h ../src/XPM.h ../src/LineMarker.h
$(DIR_O)\PerLine.obj: ../src/PerLine.cxx ../include/Platform.h \
  ../include/Scintilla.h ../src/SVector.h ../src/SplitVector.h \
  ../src/Partitioning.h ../src/RunStyles.h ../src/PerLine.h
$(DIR_O)\PlatWin.obj: PlatWin.cxx ../include/Platform.h \
  ../src/UniConversion.h ../src/XPM.h
$(DIR_O)\PositionCache.obj: ../src/Editor.cxx ../include/Platform.h ../include/Scintilla.h \
  ../src/ContractionState.h ../src/SVector.h ../src/SplitVector.h \
  ../src/Partitioning.h ../src/CellBuffer.h ../src/KeyMap.h \
  ../src/RunStyles.h ../src/Indicator.h ../src/XPM.h ../src/LineMarker.h \
  ../src/Style.h ../src/ViewStyle.h ../src/CharClassify.h \
  ../src/Decoration.h ../src/Document.h ../src/Editor.h ../src/Selection.h ../src/PositionCache.h
$(DIR_O)\PropSetSimple.obj: ../lexlib/PropSetSimple.cxx ../include/Platform.h
$(DIR_O)\RESearch.obj: ../src/RESearch.cxx ../src/CharClassify.h ../src/RESearch.h
$(DIR_O)\RunStyles.obj: ../src/RunStyles.cxx ../include/Platform.h \
  ../include/Scintilla.h ../src/SplitVector.h ../src/Partitioning.h \
  ../src/RunStyles.h
$(DIR_O)\ScintillaBase.obj: ../src/ScintillaBase.cxx ../include/Platform.h \
  ../include/Scintilla.h \
  ../src/ContractionState.h ../src/SVector.h ../src/SplitVector.h \
  ../src/Partitioning.h ../src/RunStyles.h ../src/CellBuffer.h \
  ../src/CallTip.h ../src/KeyMap.h ../src/Indicator.h ../src/XPM.h \
  ../src/LineMarker.h ../src/Style.h ../src/ViewStyle.h \
  ../src/AutoComplete.h ../src/CharClassify.h ../src/Decoration.h \
  ../src/Document.h ../src/Editor.h ../src/Selection.h ../src/ScintillaBase.h
$(DIR_O)\ScintillaBaseL.obj: ../src/ScintillaBase.cxx ../include/Platform.h \
  ../include/Scintilla.h \
  ../src/ContractionState.h ../src/SVector.h ../src/SplitVector.h \
  ../src/Partitioning.h ../src/RunStyles.h ../src/CellBuffer.h \
  ../src/CallTip.h ../src/KeyMap.h ../src/Indicator.h ../src/XPM.h \
  ../src/LineMarker.h ../src/Style.h ../src/ViewStyle.h \
  ../src/AutoComplete.h ../src/CharClassify.h ../src/Decoration.h \
  ../src/Document.h ../src/Editor.h ../src/Selection.h ../src/ScintillaBase.h
$(DIR_O)\ScintillaWin.obj: ScintillaWin.cxx ../include/Platform.h \
  ../include/Scintilla.h ../src/ContractionState.h \
  ../src/SVector.h ../src/SplitVector.h ../src/Partitioning.h \
  ../src/RunStyles.h ../src/CellBuffer.h ../src/CallTip.h ../src/KeyMap.h \
  ../src/Indicator.h ../src/XPM.h ../src/LineMarker.h ../src/Style.h \
  ../src/AutoComplete.h ../src/ViewStyle.h ../src/CharClassify.h \
  ../src/Decoration.h ../src/Document.h ../src/Editor.h \
  ../src/ScintillaBase.h ../src/Selection.h ../src/UniConversion.h
$(DIR_O)\ScintillaWinS.obj: ScintillaWin.cxx ../include/Platform.h \
  ../include/Scintilla.h ../src/ContractionState.h \
  ../src/SVector.h ../src/SplitVector.h ../src/Partitioning.h \
  ../src/RunStyles.h ../src/CellBuffer.h ../src/CallTip.h ../src/KeyMap.h \
  ../src/Indicator.h ../src/XPM.h ../src/LineMarker.h ../src/Style.h \
  ../src/AutoComplete.h ../src/ViewStyle.h ../src/CharClassify.h \
  ../src/Decoration.h ../src/Document.h ../src/Editor.h \
  ../src/ScintillaBase.h ../src/Selection.h ../src/UniConversion.h
$(DIR_O)\ScintillaWinL.obj: ScintillaWin.cxx ../include/Platform.h \
  ../include/Scintilla.h ../src/ContractionState.h \
  ../src/SVector.h ../src/SplitVector.h ../src/Partitioning.h \
  ../src/RunStyles.h ../src/CellBuffer.h ../src/CallTip.h ../src/KeyMap.h \
  ../src/Indicator.h ../src/XPM.h ../src/LineMarker.h ../src/Style.h \
  ../src/AutoComplete.h ../src/ViewStyle.h ../src/CharClassify.h \
  ../src/Decoration.h ../src/Document.h ../src/Editor.h \
  ../src/ScintillaBase.h ../src/Selection.h ../src/UniConversion.h
$(DIR_O)\Selection.obj: ../src/Selection.cxx ../include/Platform.h ../include/Scintilla.h \
  ../src/Selection.h
$(DIR_O)\Style.obj: ../src/Style.cxx ../include/Platform.h ../include/Scintilla.h \
  ../src/Style.h
$(DIR_O)\StyleContext.obj: ../lexlib/StyleContext.cxx ../lexlib/Accessor.h \
  ../lexlib/StyleContext.h
$(DIR_O)\UniConversion.obj: ../src/UniConversion.cxx ../src/UniConversion.h
$(DIR_O)\ViewStyle.obj: ../src/ViewStyle.cxx ../include/Platform.h \
  ../include/Scintilla.h ../src/SplitVector.h ../src/Partitioning.h \
  ../src/RunStyles.h ../src/Indicator.h ../src/XPM.h ../src/LineMarker.h \
  ../src/Style.h ../src/ViewStyle.h
$(DIR_O)\WordList.obj: ../lexlib/WordList.cxx ../lexlib/WordList.h
$(DIR_O)\XPM.obj: ../src/XPM.cxx ../include/Platform.h ../src/XPM.h
