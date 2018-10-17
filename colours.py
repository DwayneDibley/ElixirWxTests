

def do_colours():
    fd = open("colours.dat")
    colours = fd.readlines()
    for colour in colours:
        do_colour(colour)

def do_colour(colour):
    name, rest = colour.split("#")
    name = do_name(name)

    hex, rgb = rest.strip().split()
    rgb = rgb.replace("(", "{")
    rgb = rgb.replace(")", "}")
    print("%s %s" % (name, rgb))

def do_name(name):
    name = name.strip()
    parts = name.split()
    name = "_".join(parts)
    name = name.upper()
    return("@wx%s" % name)




if __name__ == "__main__":
    do_colours()
