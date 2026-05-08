#include "foo/foo.hpp"

void Foo::_bind_methods() {
    godot::ClassDB::bind_method(D_METHOD("print_type", "variant"), &Foo::print_type);
    godot::ClassDB::bind_method(D_METHOD("say_hello", "sb"), &Foo::say_hello);
}

void Foo::print_type(const Variant &p_variant) const {
    print_line(vformat("Type: %d", p_variant.get_type()));
}

void Foo::say_hello(const String &p_sb) const {
    print_line(vformat("Hello %s, I am Foo.", p_sb));
}
