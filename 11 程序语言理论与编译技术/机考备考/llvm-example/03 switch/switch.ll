; ModuleID = './switch.cpp'
source_filename = "./switch.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: mustprogress noinline norecurse nounwind optnone uwtable
define dso_local noundef i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  store i32 3, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  switch i32 %3, label %13 [
    i32 1, label %4
    i32 3, label %7
    i32 4, label %10
  ]

4:                                                ; preds = %0
  %5 = load i32, i32* %2, align 4
  %6 = add nsw i32 %5, 1
  store i32 %6, i32* %2, align 4
  br label %13

7:                                                ; preds = %0
  %8 = load i32, i32* %2, align 4
  %9 = add nsw i32 %8, 3
  store i32 %9, i32* %2, align 4
  br label %10

10:                                               ; preds = %0, %7
  %11 = load i32, i32* %2, align 4
  %12 = add nsw i32 %11, 4
  store i32 %12, i32* %2, align 4
  br label %13

13:                                               ; preds = %0, %10, %4
  %14 = load i32, i32* %2, align 4
  ret i32 %14
}

attributes #0 = { mustprogress noinline norecurse nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.6"}
