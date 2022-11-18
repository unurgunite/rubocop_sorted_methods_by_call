#include "rubocop_sorted_methods_by_call.h"

VALUE rb_mRubocopSortedMethodsByCall;

void
Init_rubocop_sorted_methods_by_call(void)
{
  rb_mRubocopSortedMethodsByCall = rb_define_module("RubocopSortedMethodsByCall");
}
