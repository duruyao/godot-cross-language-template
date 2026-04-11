#pragma once

#include "godot_cpp/classes/ref_counted.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include "godot_cpp/variant/variant.hpp"

using namespace godot;

class Foo : public RefCounted {
	GDCLASS(Foo, RefCounted)

protected:
	static void _bind_methods();

public:
	Foo() = default;
	~Foo() override = default;

	void print_type(const Variant &p_variant) const;
};
