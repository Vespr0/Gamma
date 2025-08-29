Error handling should be extensive but not verbose.

---

Use `assert` when it is more clean then using ifs and errors.

---

When using pcalls it only outputs the last error not the whole error stack.

---

Use `warn()` when the issue is not game breaking, this includes visual effects, ui animations and addiotionally things that are functional but if you were to use an error you would stop the whole script and that's not good either. Reserve `error()` for critical things.

