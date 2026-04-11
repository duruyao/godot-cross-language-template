#pragma once

#include "godot_cpp/classes/ref_counted.hpp"
#include "godot_cpp/classes/wrapped.hpp"
#include "godot_cpp/variant/variant.hpp"

using namespace godot;

class Bar : public RefCounted {
	GDCLASS(Bar, RefCounted)

protected:
	static void _bind_methods();

public:
	Bar() = default;
	~Bar() override = default;

	void print_type(const Variant &p_variant) const;
};
