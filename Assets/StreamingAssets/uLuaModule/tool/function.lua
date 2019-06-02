function Handler(func, target)
    return function(...) return func(target, ...) end
end