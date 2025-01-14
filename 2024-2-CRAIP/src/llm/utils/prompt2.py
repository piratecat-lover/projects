# First prompt: Avoid human, go to AC

def avoid_human(instr = "Avoid human, go to AC"):
    code_gen = "Go to the table, then move to the chair, then go to the AC."
    return get_code_generation_shot(code_gen)

# Second prompt: Push the ball into the goalpost

def push_ball(instr = "Push the ball into the goalpost"):
    code_gen = "Go to the right of the ball, then move to the goalpost."
    return get_code_generation_shot(code_gen)

# Third prompt: Go to the door, wait for the door to open, then go inside.

def pass_door(instr = "Go to the door, wait for the door to open, then go inside."):
    code_gen = "Go to the door, wait 10 seconds, then go to the near wall."
    return get_code_generation_shot(code_gen)