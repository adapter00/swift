// RUN: rm -rf %t && mkdir %t
// RUN: %target-swift-frontend -emit-module -enable-resilience -emit-module-path=%t/resilient_struct.swiftmodule -module-name=resilient_struct %S/../Inputs/resilient_struct.swift
// RUN: %target-swift-frontend -emit-module -enable-resilience -emit-module-path=%t/resilient_class.swiftmodule -module-name=resilient_class -I %t %S/../Inputs/resilient_class.swift
// RUN: %target-swift-frontend -Xllvm -new-mangling-for-tests -I %t -emit-silgen -enable-resilience %s | %FileCheck %s

import resilient_class

// Accessing final property of resilient class from different resilience domain
// through accessor

// CHECK-LABEL: sil @_T016class_resilience20finalPropertyOfOthery010resilient_A022ResilientOutsideParentCF
// CHECK: function_ref @_T015resilient_class22ResilientOutsideParentC13finalPropertySSfg

public func finalPropertyOfOther(_ other: ResilientOutsideParent) {
  _ = other.finalProperty
}

public class MyResilientClass {
  public final var finalProperty: String = "MyResilientClass.finalProperty"
}

// Accessing final property of resilient class from my resilience domain
// directly

// CHECK-LABEL: sil @_T016class_resilience19finalPropertyOfMineyAA16MyResilientClassCF
// CHECK: ref_element_addr %0 : $MyResilientClass, #MyResilientClass.finalProperty

public func finalPropertyOfMine(_ other: MyResilientClass) {
  _ = other.finalProperty
}

