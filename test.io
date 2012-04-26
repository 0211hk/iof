re := Python import("re")

s1 := re sub( "(.)([A-Z][a-z]+)", "\\1_\\2", "CamelCase")
re sub("([a-z0-9])([A-Z])", "\\1_\\2", s1) asLowercase println
