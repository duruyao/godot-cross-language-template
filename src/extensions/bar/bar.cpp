#include "bar/bar.hpp"

void Bar::_bind_methods() {
    godot::ClassDB::bind_method(D_METHOD("print_type", "variant"), &Bar::print_type);
    godot::ClassDB::bind_method(D_METHOD("say_hello", "sb"), &Bar::say_hello);
}

void Bar::print_type(const Variant &p_variant) const {
    print_line(vformat("Type: %d", p_variant.get_type()));
}

void Bar::say_hello(const String &p_sb) const {
    print_line(vformat("Hello %s, I am Bar.", p_sb));
}
