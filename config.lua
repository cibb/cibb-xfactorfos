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
        g=117,
        b=0,
        intensity = 30.00
    },
}


Locales = {}