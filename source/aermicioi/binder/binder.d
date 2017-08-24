module aermicioi.binder.binder;

alias Setter(T) = void delegate (ref T value);

/**
A structure that wraps up a value of type T, and fires a callback when value is set.
**/
struct SetEventFiringValue(T) {

    private {
        T value_;
        Setter!T setter_;
    }

    public {

        @property {
            /**
            Set setter
            
            Params: 
                setter = the callback executed when value set occurs
            
            Returns:
                typeof(this)
            **/
            typeof(this) setter(Setter!T setter) @safe nothrow pure {
                this.setter_ = setter;
            
                return this;
            }
            
            /**
            Get setter
            
            Returns:
                Setter!T
            **/
            Setter!T setter() @safe nothrow pure {
                return this.setter_;
            }

            /**
            Set value
            
            Params: 
                value = the contained value
            
            Returns:
                typeof(this)
            **/
            typeof(this) value(T value) {
                this.value_ = value;
                this.setter_(this.value_);
            
                return this;
            }
            
            /**
            Get value
            
            Returns:
                T
            **/
            T value() {
                return this.value_;
            }

            alias value this;
        }
    }
}

/**
Create one way binding from content to value.

Create one way binding from content to value. When value in content is updated
the value is automatically updated with new value as well.

Params: 
    content = the value that is binding it's data to value
    value = the value that is binded to content
Returns:
    SetEventFiringValue!T the content
**/
auto bind(T)(auto ref SetEventFiringValue!T content,  ref T value) {
    if (content.setter is null) {

        content.setter = delegate void(ref T a) { value = a; };
        return content;
    }
    
    auto parent = content.setter;
    content.setter = delegate void(ref T a) { parent(a); value = a; };
    
    return content;
}

/**
ditto
**/
auto bind(T)(auto ref T content,  ref T value) {
    return SetEventFiringValue!T(content).bind(value);
}

/**
ditto
**/
auto bind(T)( ref T value) {
    SetEventFiringValue!T b;
    b.bind(value);

    return b;
}

/**
Create a two way binding.

Create a two way binding. On first being modified changes are propagated to second and vice versa.

Params: 
    first = the first binded value
    second = the second binded value
**/
void tbind(T)(auto ref SetEventFiringValue!T first, auto ref SetEventFiringValue!T second) {
    first.bind(second.value_);
    second.bind(first.value_);
}

/**
ditto
**/
auto tbind(T)( ref SetEventFiringValue!T value) {
    auto b = SetEventFiringValue!T();
    b.tbind(value);
    return b;
}