#include "foo/foo.hpp"

void Foo::_bind_methods() {
	godot::ClassDB::bind_method(D_METHOD("print_type", "variant"), &Foo::print_type);
}

void Foo::print_type(const Variant &p_variant) const {
	print_line(vformat("Type: %d", p_variant.get_type()));
}
