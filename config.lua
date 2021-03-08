Config = {}

-- Locale
Config.Locale = 'es'

-- Judges identifiers (Steam, License, or any other requirement)
Config.judges = {
    "", -- For Example license:5d46asdasd8bfb8a5889f1df3c020fasdasdasdas
    "",
    ""
}

-- Internal configuration
-- -----------------------------------------------------------------------------
-- |    Don't touch anything if you are not sure about what are you doing      |
-- -----------------------------------------------------------------------------

-- You may replace it for your desired license type (steamid, license, discord, etc).
-- Make sure that you are using the same in judges list config.
Config.identifier_used = "steamid"

Config.propagation_distance = 10

Config.sound = {
    volume = 0.75
}

-- Visual Configuration
Config.buzzers = {
    fail = {
        r=250,
        g=0,
        b=0,
        intensity = 15.00
    },
    gold = {
        r=153,
        g=51,
        b=0,        
        intensity = 50.00
    },
}

-- Lights positions
Config.lightsPositions = {
    [1] = {
        x= -230.0,
        y= -2001.00,
        z=  23.8
    },
    [2] = {
        x= -235.0,
        y= -2001.00,
        z=  23.8
    },
    [3] = {
        x= -235.00,
        y= -2005.45,
        z=  23.8
    }
}

-- Confetti positions
Config.confettiPosittions = {
    [1] = {
        x= -232.5,
        y= -2001.29,
        z=  23.8
    },
    [2] = {
        x= -237.43,
        y= -1999.81,
        z=  23.8
    },
    [3] = {
        x= -232.83,
        y= -2003.81,
        z=  23.8
    },
    [4] = {
        x= -238.15,
        y= -2002.61,
        z=  23.8
    },
}

Locales = {}