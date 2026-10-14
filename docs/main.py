def define_env(env):
    env.variables["checked"] = ":fontawesome-regular-square-check:"
    env.variables["unchecked"] = ":fontawesome-regular-square:"
    env.variables["yes"] = env.variables["checked"]
    env.variables["no"] = env.variables["unchecked"]
