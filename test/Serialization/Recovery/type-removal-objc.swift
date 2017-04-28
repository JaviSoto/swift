// RUN: rm -rf %t && mkdir -p %t
// RUN: %target-swift-frontend -emit-module -o %t -module-name Lib -I %S/Inputs/custom-modules %s

// RUN: %target-swift-ide-test -source-filename=x -print-module -module-to-print Lib -I %t -I %S/Inputs/custom-modules | %FileCheck %s

// RUN: %target-swift-ide-test -source-filename=x -print-module -module-to-print Lib -I %t -I %S/Inputs/custom-modules -Xcc -DBAD -enable-experimental-deserialization-recovery > %t.txt
// RUN: %FileCheck -check-prefix CHECK-RECOVERY %s < %t.txt
// RUN: %FileCheck -check-prefix CHECK-RECOVERY-NEGATIVE %s < %t.txt

// REQUIRES: objc_interop

import TypeRemovalObjC

// CHECK-DAG: let simple: AnyObject?
// CHECK-RECOVERY-DAG: let simple: AnyObject?
public let simple: AnyObject? = nil

// CHECK-DAG: let someObject: Base?
// CHECK-RECOVERY-NEGATIVE-NOT: let someObject:
public let someObject: Base? = nil
// CHECK-DAG: let someGenericObject: Generic<AnyObject>?
// CHECK-RECOVERY-NEGATIVE-NOT: let someGenericObject:
public let someGenericObject: Generic<AnyObject>? = nil
// CHECK-DAG: let someProtoValue: SomeProto?
// CHECK-RECOVERY-NEGATIVE-NOT: let someProtoValue:
public let someProtoValue: SomeProto? = nil
// CHECK-DAG: let someProtoType: SomeProto.Type?
// CHECK-RECOVERY-NEGATIVE-NOT: let someProtoType:
public let someProtoType: SomeProto.Type? = nil
// CHECK-DAG: let someProtoCompositionValue: (AProto & SomeProto)?
// CHECK-RECOVERY-NEGATIVE-NOT: let someProtoCompositionValue:
public let someProtoCompositionValue: (AProto & SomeProto)? = nil
// CHECK-DAG: let someProtoCompositionValue2: (SomeProto & ZProto)?
// CHECK-RECOVERY-NEGATIVE-NOT: let someProtoCompositionValue2:
public let someProtoCompositionValue2: (SomeProto & ZProto)? = nil

// CHECK-DAG: unowned var someUnownedObject: @sil_unowned Base
// CHECK-RECOVERY-NEGATIVE-NOT: var someUnownedObject:
public unowned var someUnownedObject: Base = Base()
// CHECK-DAG: unowned(unsafe) var someUnownedUnsafeObject: @sil_unmanaged Base
// CHECK-RECOVERY-NEGATIVE-NOT: var someUnownedUnsafeObject:
public unowned(unsafe) var someUnownedUnsafeObject: Base = Base()
// CHECK-DAG: weak var someWeakObject: @sil_weak Base
// CHECK-RECOVERY-NEGATIVE-NOT: var someWeakObject:
public weak var someWeakObject: Base? = nil