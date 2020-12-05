; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

; rdar://11245199
; PR12545

declare dso_local void @g()

define void @neg_cmp(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: neg_cmp:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addl %esi, %edi
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:  # %bb.2: # %if.then
; CHECK-NEXT:    jmp g # TAILCALL
; CHECK-NEXT:  .LBB0_1: # %if.end
; CHECK-NEXT:    retq
  %sub = sub i32 0, %y
  %cmp = icmp eq i32 %x, %sub
  br i1 %cmp, label %if.then, label %if.end

if.then:
  tail call void @g() nounwind
  br label %if.end

if.end:
  ret void
}

define void @neg_cmp_commuted(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: neg_cmp_commuted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addl %esi, %edi
; CHECK-NEXT:    jne .LBB1_1
; CHECK-NEXT:  # %bb.2: # %if.then
; CHECK-NEXT:    jmp g # TAILCALL
; CHECK-NEXT:  .LBB1_1: # %if.end
; CHECK-NEXT:    retq
  %sub = sub i32 0, %y
  %cmp = icmp eq i32 %sub, %x
  br i1 %cmp, label %if.then, label %if.end

if.then:
  tail call void @g() nounwind
  br label %if.end

if.end:
  ret void
}

