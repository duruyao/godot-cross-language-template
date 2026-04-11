#include "bar.hpp"

void Bar::_bind_methods() {
	godot::ClassDB::bind_method(D_METHOD("print_type", "variant"), &Bar::print_type);
}

void Bar::print_type(const Variant &p_variant) const {
	print_line(vformat("Type: %d", p_variant.get_type()));
}
